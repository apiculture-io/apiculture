require 'thor'

module Apiculture
  class Cli < Thor
    include Thor::Actions

    package_name "Apiculture"

    desc "list", "List all installed templates"
    def list
      print_template = lambda { |template|
        puts "\t#{template.name}"
      }

      puts "Installed templates:"
      template_registry.list.each(&print_template)
    end

    desc "install URI", "Install an Apiculture template"
    method_option(:force,
                  :aliases => "-f",
                  :desc => "If the template is already installed, delete it first.",
                  :default => false,
                  :type => :boolean)
    def install(uri)
      template = template_registry.install(uri, { :force => options.force })
      say "Successfully installed template #{template.name}"
    rescue
      say $!.message, :red
      exit -1
    end

    no_commands do
      def config
        @config ||= ::Apiculture::Config.new
      end

      def template_registry
        @template_registry ||= ::Apiculture::TemplateRegistry.new(config)
      end
    end
  end
end
