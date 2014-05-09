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

  def initialize(config, path)
    @path = path
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
    File.open(File.join(path, BASE_NAME)) do |file|
      file.puts(to_yaml)
    end
  end
end
