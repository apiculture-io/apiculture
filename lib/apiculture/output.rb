# An "output" is a mix of a template, a manifest and template parameters that
# defines how the output should be generated.
class Apiculture::Output
  attr_accessor :template, :manifest, :options

  def initialize(template, manifest, options=nil)
    @template = template
    @manifest = manifest
    @options = options || {}
  end

  def self.from_yaml(manifest, yaml)
    template = manifest.config.template_registry.find_by_url(yaml["template"])
    return self.new(template, manifest, yaml["options"])
  end

  def as_yaml
    return {
      "template" => template.url,
      "options" => options
    }
  end
end
