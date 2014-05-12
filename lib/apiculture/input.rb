require "pathname"

module Apiculture
  class Input
    attr_accessor :manifest

    def initialize(manifest)
      @manifest = manifest
    end

    def proto_files
      return Dir.glob("#{manifest.descriptor_path}/**/*.proto")
    end

    def load_descriptor
    end

    def invoke_protoc(output_type, output_path)
      extension_import_path = File.realpath(File.join(File.dirname(__FILE__), "..", "..", "protos"))
      command = ["protoc", "-I.", "-I#{extension_import_path}"]
      command << "--#{output_type}_out=#{output_path}"
      command += proto_files.map { |path|
        Pathname.new(path).relative_path_from(Pathname.new(manifest.descriptor_path)).to_s
      }
      puts command.inspect

      Dir.chdir(manifest.descriptor_path) do
        system("which", "protoc")
        system(*command)
      end
    end
  end
end
