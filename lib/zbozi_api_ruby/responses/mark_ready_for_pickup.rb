require 'zbozi_api_ruby/responses/base'

module ZboziApiRuby
  module Response
    class MarkReadyForPickup < Base
      def initialize(json)
        super(json)
      end
    end
  end
end
