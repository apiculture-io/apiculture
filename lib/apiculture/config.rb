require 'rubygems'
require 'pathname'

module Apiculture
  class Config
    # User's home directory
    HOME = Gem.user_home

    attr_accessor :config_dir, :options_file, :template_dir

    class << self
      attr_accessor :config_dir, :options_file

      def config_dir
        @config_dir || File.join(HOME, '.apiculture')
      end

      def reset_config_dir!
        remove_instance_variable(:@config_dir)
      end

      def options_file
        @options_file || File.join(config_dir, "options.yml")
      end

      def reset_options_file!
        remove_instance_variable(:@options_file)
      end

      def template_dir
        @template_dir || File.join(config_dir, "templates")
      end

      def reset_template_dir!
        remove_instance_variable(:@template_dir)
      end

    end

    def config_dir
      @config_dir || self.class.config_dir
    end

    def options_file
      @options_file || self.class.options_file
    end

    def template_dir
      @template_dir || self.class.template_dir
    end

    def template_registry_file
      File.join(self.template_dir, "templates.yml")
    end
  end
end
