require "apiculture/version"

module Apiculture
  autoload :Cli, "apiculture/cli"
  autoload :Config, "apiculture/config"
  autoload :Input, "apiculture/input"
  autoload :Manifest, "apiculture/manifest"
  autoload :Output, "apiculture/output"
  autoload :Template, "apiculture/template"
  autoload :TemplateRegistry, "apiculture/template_registry"
  autoload :StringUtils, "apiculture/string_utils"

  def self.register_template
    yield ::Apiculture::Template.__loading_template
  end
end
