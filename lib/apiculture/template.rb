require 'fileutils'
require 'uri'

module Apiculture
  class Template
    attr_accessor :path, :descriptor

    def name
      descriptor["name"]
    end
  end
end
