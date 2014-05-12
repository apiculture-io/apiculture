# An "output" is a mix of a template, a manifest and template parameters that
# defines how the output should be generated.
class Apiculture::Output
  attr_accessor :template_uri, :manifest, :options

  def initialize(template_uri, manifest, options=nil)
    @template_uri = template_uri
    @manifest = manifest
    @options = options || {}
  end

  def template
    @template ||= manifest.config.template_registry.find_by_url(template_uri)
  end

  def self.from_yaml(manifest, yaml)
    return self.new(yaml["template"], manifest, yaml["options"])
  end

  def as_yaml
    return {
      "template" => template.url,
      "options" => options
    }
  end
end
