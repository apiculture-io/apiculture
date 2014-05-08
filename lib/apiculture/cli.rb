require 'thor'

module Apiculture
  class Cli < Thor
    include Thor::Actions

    package_name "Apiculture"

    desc "list", "List all installed templates"
    def list
      print_template = lambda { |template|
        puts "\t#{template.name} - #{template.path}"
      }

      puts "Installed templates:"
      template_registry.list.each(&print_template)
    end

    desc "install URI", "Install an Apiculture template"
    method_option(:force,
                  :aliases => "-f",
                  :desc => "If the template is already installed, reinstall.",
                  :default => false,
                  :type => :boolean)
    def install(uri)
      template = template_registry.install(uri, { :force => options.force })
      say "Successfully installed template #{template.name}"
    rescue
      say $!.message, :red
      exit -1
    end

    desc "update TEMPLATE_NAME", "Update an installed Apiculture template"
    def update(template_name)
      template = template_registry.find_by_name(template_name)
      template.update!
      say "Successfully updated template #{template.name}"
    rescue
      say $!.message, :red
      say $!.backtrace.join("\n")
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
