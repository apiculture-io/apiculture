require "pathname"
require "tempfile"
require "protobuf_descriptor"

module Apiculture
  class Input
    attr_accessor :manifest

    def initialize(manifest)
      @manifest = manifest
    end

    def proto_files
      return Dir.glob("#{manifest.descriptor_path}/**/*.proto")
    end

    def descriptor
      @descriptor ||= load_descriptor
    end

    # output_type is one of [:java, :python, :cpp, :descriptor]
    def invoke_protoc(output_type, output_path)
      # Load the file that the apiculture extensions are defined in.
      require "apiculture_extensions.pb.rb"

      extension_import_path = File.realpath(File.join(File.dirname(__FILE__), "..", "..", "protos"))

      command = ["protoc", "-I.", "-I#{extension_import_path}"]
      if output_type == :descriptor
        command += ["--include_source_info", "--descriptor_set_out=#{output_path}"]
      else
        command << "--#{output_type}_out=#{output_path}"
      end

      command += proto_files.map { |path|
        Pathname.new(path).relative_path_from(Pathname.new(manifest.descriptor_path)).to_s
      }

      Dir.chdir(manifest.descriptor_path) do
        system(*command)
      end
    end

    private
    def load_descriptor
      file = Tempfile.new(["descriptor", "desc"])
      begin
        invoke_protoc(:descriptor, file.path)
        return ProtobufDescriptor.load(file.path)
      ensure
        file.close
        file.unlink
      end
    end
  end
end
