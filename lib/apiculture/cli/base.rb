require "thor"

class Apiculture::Cli::Base < Thor
  include Thor::Actions

  class_option :verbose, :type => :boolean
  class_option :config_dir, :type => :string

  no_commands do
    def config
      @config ||= ::Apiculture::Config.build do |config|
        if options.config_dir && options.config_dir.strip != ""
          config.config_dir = options.config_dir
        end
      end
    end

    def template_registry
      @template_registry ||= config.template_registry
    end

    def manifest
      @manifest ||= ::Apiculture::Manifest.load(config, File.expand_path("."))
    end

    def create_file_from_template(source, *args, &block)
      config = args.last.is_a?(Hash) ? args.pop : {}
      destination = args.first || source.sub(/\.tt$/, "")

      # Minor difference between regular thor and Apiculture, we ignore the
      # destination root, since that usually has more to do with the nested
      # directory for each template.
      source  = File.expand_path(find_in_root_source_paths(source.to_s))
      context = instance_eval("binding")

      create_file destination, nil, config do
        content = ERB.new(::File.binread(source), nil, "-", "@output_buffer").result(context)
        content = block.call(content) if block
        content
      end
    end

    def find_in_root_source_paths(file)
      possible_files = [file, "#{file}.tt"]
      relative_root = relative_to_original_destination_root(destination_root, false)

      source_paths.each do |source|
        possible_files.each do |f|
          source_file = File.expand_path(f, source)
          return source_file if File.exist?(source_file)
        end
      end

      message = "Could not find #{file.inspect} in any of your source paths. "

      unless self.class.source_root
        message << "Please invoke #{self.class.name}.source_root(PATH) with the PATH containing your templates. "
      end

      if source_paths.empty?
        message << "Currently you have no source paths."
      else
        message << "Your current source paths are: \n#{source_paths.join("\n")}"
              end

      fail Error, message
    end
  end
end
