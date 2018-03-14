require 'zbozi_api_ruby/responses/base'

module ZboziApiRuby
  module Response
    class MarkEnRoute < Base
      attr_reader :expected_delivery_date
      
      def initialize(json)
        super(json)
      end
    end
  end
end
