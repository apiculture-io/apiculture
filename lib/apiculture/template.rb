require 'fileutils'
require 'uri'

module Apiculture
  class Template
    autoload :Builder, "apiculture/template/builder"

    class << self
      attr_accessor :__loading_template
    end

    attr_accessor :descriptor
    attr_accessor :loaded_template

    def name
      descriptor["name"]
    end

    def path
      descriptor["path"]
    end

    def url
      descriptor["url"]
    end

    def update!
      Dir.chdir(path) do
        system('git', 'pull')
      end
    end

    def load_template!
      return if @loaded_template

      @loaded_template = self.class.__loading_template = ::Apiculture::Template::Builder.new(self)
      Kernel.load(File.join(path, "init.rb"))
      self.class.__loading_template = nil
    end

    def configure_options_proc
      load_template!
      return loaded_template.configure_options_proc
    end

    def generate_proc
      load_template!
      return loaded_template.generate_proc
    end
  end
end
