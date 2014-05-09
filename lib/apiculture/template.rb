require 'fileutils'
require 'uri'

module Apiculture
  class Template
    attr_accessor :descriptor

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
  end
end
