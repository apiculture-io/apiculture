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
      FileUtils.mkdir_p(File.dirname(@path)) unless File.exists?(File.dirname(@path))
      File.open(path, "w+") do |f|
        f.write(registry.to_yaml)
      end
    end

    def install(url, options={})
      options = { :force => false }.merge(options)

      url_hash = Digest::MD5.hexdigest(url)

      is_remote = /^(https?|git):\/\//.match(url) || url.end_with?(".git")
      name = File.basename(url, ".git")

      path = File.join(config.template_dir, url_hash)
      path = File.realpath(url) if !is_remote

      if is_remote
        if File.directory?(path)
          if options[:force]
            FileUtils.rm_rf(path)
          else
            raise "Template #{name} already installed."
          end
        end

        FileUtils.mkdir_p(path)
        system("git", "clone", url, path)
      end

      self.registry[url_hash] = registry_entry = {
        "name" => name,
        "url" => url,
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

    def find_by_name(name)
      self.list.find { |template| template.name == name }
    end
  end
end
