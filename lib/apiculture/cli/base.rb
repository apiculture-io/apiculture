require "thor"

class Apiculture::Cli::Base < Thor
  include Thor::Actions

  class_option :verbose, :type => :boolean
  class_option :config_dir, :type => :string

  no_commands do
    def maybe_write_file(destination, &blk)
      if !File.exists?(destination) || file_collision(destination, &blk)
        File.open(destination, "w") do |file|
          file.puts yield
        end
      end
    end

    def config
      @config ||= ::Apiculture::Config.build do |config|
        if options.config_dir && options.config_dir.strip != ""
          config.config_dir = options.config_dir
        end
      end
    end

    def template_registry
      @template_registry ||= ::Apiculture::TemplateRegistry.new(config)
    end
  end
end
