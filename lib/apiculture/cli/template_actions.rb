class Apiculture::Cli::TemplateActions < Apiculture::Cli::Base
  include Thor::Actions

  desc "list", "List all installed templates"
  def list
    say "Installed templates:"
    print_table template_registry.list.map { |template| [template.name, template.path, template.url] }
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
end
