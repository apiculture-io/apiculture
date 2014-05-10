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
  end
end
