require 'apiculture/cli/template_actions'

class Apiculture::Cli::Main < Thor
  desc "init", "Initializes an Apiculture API definition"
  def init
  end

  desc "template SUBCOMMAND ...ARGS", "manage installed templates"
  subcommand "template", Apiculture::Cli::TemplateActions
end
