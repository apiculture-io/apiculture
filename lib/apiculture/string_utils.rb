module Apiculture
  # Provides various string formatting methods, this code is ripped from extlib
  # (https://github.com/datamapper/extlib/blob/master/lib/extlib/string.rb). Notably,
  # not stolen from activesupport, though method aliases are set up so they can
  # be used using the activesupport names.
  module StringUtils
    class << self
      # Convert to snake case.
      #
      #   "FooBar".snake_case           #=> "foo_bar"
      #   "HeadlineCNNNews".snake_case  #=> "headline_cnn_news"
      #   "CNN".snake_case              #=> "cnn"
      #
      # @return [String] Receiver converted to snake case.
      def snake_case(str)
        return nil if str.nil?

        str = str.to_s
        return str.downcase if str.match(/\A[A-Z]+\z/)
        str.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z])([A-Z])/, '\1_\2').
          downcase
      end

      alias_method :underscore, :snake_case
      alias_method :underscoreize, :snake_case

      # Convert to camel case.
      #
      #   "foo_bar".camel_case          #=> "FooBar"
      #
      # @return [String] Receiver converted to camel case.
      def camel_case(str, first_letter=:upper)
        return nil if str.nil?

        str = str.to_s
        return str if str !~ /_/ && str =~ /[A-Z]+.*/

        str = str.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }

        str = str[0, 1].downcase + str[1..-1] if first_letter != :upper

        return str
      end
      alias_method :camelize, :camel_case


      # Convert a path string to a constant name.
      #
      #   "merb/core_ext/string".to_const_string #=> "Merb::CoreExt::String"
      #
      # @return [String] Receiver converted to a constant name.
      #
      def to_const_string(str)
        str.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      end

      # Convert a constant name to a path, assuming a conventional structure.
      #
      #   "FooBar::Baz".to_const_path # => "foo_bar/baz"
      #
      # @return [String] Path to the file containing the constant named by receiver
      #   (constantized string), assuming a conventional structure.
      #
      def to_const_path(str)
        self.snake_case(str).gsub(/::/, "/")
      end
    end
  end
end
