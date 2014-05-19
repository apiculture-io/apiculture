require "yaml"

class Apiculture::Manifest
  BASE_NAME = ".apiculture.yml"

  # The config instance
  attr_accessor :config

  # The name of the API
  attr_accessor :name

  # Short one line description of what the API does
  attr_accessor :summary

  # One paragraph description of what the API does
  attr_accessor :description

  # The full path to the directory containing this manifest
  attr_accessor :path

  # The sub-directory containing the Apiculture api descriptor
  attr_accessor :descriptor_dir

  # Array of Output instances
  attr_accessor :outputs

  def initialize(config, path)
    @config = config
    @path = path
    @outputs = []
    yield self if block_given?
  end

  def as_yaml
    return {
        "name" => self.name,
        "summary" => self.summary,
        "description" => self.description,
        "descriptor_dir" => self.descriptor_dir,
        "outputs" => self.outputs.map { |out| out.as_yaml }
      }
  end

  def to_yaml
    YAML.dump(as_yaml)
  end

  def write!
    File.open(File.join(path, BASE_NAME), "w") do |file|
      file.puts(to_yaml)
    end
  end

  def descriptor_path
    return File.join(path, descriptor_dir)
  end

  def input
    @input ||= Apiculture::Input.new(self)
  end

  def self.load(config, path)
    yaml = YAML.load_file(File.join(path, BASE_NAME))
    return self.new(config, path) do |manifest|
      manifest.name = yaml["name"]
      manifest.summary = yaml["summary"]
      manifest.description = yaml["description"]
      manifest.descriptor_dir = yaml["descriptor_dir"]
      manifest.outputs = (yaml["outputs"] || []).map { |y|
        Apiculture::Output.from_yaml(manifest, y)
      }
    end
  end
end
