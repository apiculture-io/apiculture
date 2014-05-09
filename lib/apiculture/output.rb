# An "output" is a mix of a template, a manifest and template parameters that
# defines how the output should be generated.
class Apiculture::Output
  attr_accessor :template, :manifest, :options

  def as_yaml
    return {
      "template" => template.url,
      "options" => options
    }
  end
end
