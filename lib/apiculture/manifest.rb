require "yaml"

class Apiculture::Manifest
  BASE_NAME = ".apiculture.yml"

  # The config instance
  attr_accessor :config

  # The name of the API
  attr_accessor :name

  # The full path to the directory containing this manifest
  attr_accessor :path

  # The sub-directory containing the Apiculture api descriptor
  attr_accessor :directory

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
        "directory" => self.directory,
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

  def self.load(config, path)
    yaml = YAML.load_file(File.join(path, BASE_NAME))
    return self.new(config, path) do |manifest|
      manifest.name = yaml["name"]
      manifest.directory = yaml["directory"]
      manifest.outputs = (yaml["outputs"] || []).map { |y|
        Apiculture::Output.from_yaml(manifest, y)
      }
    end
  end
end
