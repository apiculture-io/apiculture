require "apiculture/template"

require "digest/md5"
require "yaml"

module Apiculture
  class TemplateRegistry
    attr_accessor :config, :path, :registry

    def initialize(config)
      @config = config
      @path = config.template_registry_file
      @registry = File.exist?(path) ? YAML.load_file(path) : {}
    end

    def write_registry!
      File.open(path, "w+") do |f|
        f.write(registry.to_yaml)
      end
    end

    def install(uri, options={})
      options = { :force => false }.merge(options)

      url = URI(uri)

      name = File.basename(url.path)
      name.gsub!(/\.git$/,'')

      url_hash = Digest::MD5.hexdigest(uri)
      path = File.join(config.template_dir, url_hash)

      if File.directory?(path)
        if options[:force]
          FileUtils.rm_rf(path)
        else
          raise "Template #{name} already installed."
        end
      end

      FileUtils.mkdir_p(path)
      system('git', 'clone', uri, path)

      self.registry[name] = registry_entry = {
        "name" => name,
        "url" => uri,
        "path" => path
      }
      self.write_registry!

      template = ::Apiculture::Template.new
      template.descriptor = registry_entry
      return template
    end

    def list
      return registry.values.map { |registry_entry|
        template = ::Apiculture::Template.new
        template.descriptor = registry_entry
        template
      }
    end
  end
end
