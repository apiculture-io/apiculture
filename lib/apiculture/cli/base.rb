require 'thor'
class Apiculture::Cli::Base < Thor
  include Thor::Actions

  no_commands do
    def config
      @config ||= ::Apiculture::Config.new
    end

    def template_registry
      @template_registry ||= ::Apiculture::TemplateRegistry.new(config)
    end
  end
end
