module ZboziApiRuby
  module Response
    class Base
      def initialize(json)
        return if json.nil?

        json.each do |key, value|
          instance_variable_set("@#{snakecase(key)}", value)
        end
      end

      private

      def parse(json, klass)
        return json.collect { |j| klass.new(j) } if json.is_a?(Array)
        return klass.new(json) if json
        nil
      end

      # https://github.com/rubyworks/facets/blob/master/lib/core/facets/string/snakecase.rb
      def snakecase(string)
        string.
        #gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr('-', '_').
        gsub(/\s/, '_').
        gsub(/__+/, '_').
        downcase
      end
    end
  end
end
