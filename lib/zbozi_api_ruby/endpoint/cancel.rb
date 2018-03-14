require 'json'

require 'zbozi_api_ruby/responses/cancel'

module ZboziApiRuby
  module Endpoint
    class Cancel
      PATH = 'zbozi-api/:endpoint_version/order/:slevomat_id/cancel'

      def initialize(client)
        @client = client
      end

      # Take a cancel_request and return the response from the API
      #
      # @param slevomat_id [String] a integer slevomat_id of the order
      # @param params [Hash] a hash that corresponds to params of the API:
      #   https://www.slevomat.cz/partner/zbozi-api#vytvoreni-storna
      # @return [Response::Cancel] object of the response
      #   does not contain anything
      #
      # @example Cancel order items with params
      #   params = {
      #     items: [
      #        {
      #          slevomatId: "45454",
      #          amount: 15
      #        }
      #     ],
      #     note: "optional note"
      #   }
      #
      #   response = client.cancel(12345, params)
      def cancel(slevomat_id, params = {})
        result = cancel_request(slevomat_id, params).body
        result = "{}" if result == ""
        Response::Cancel.new(JSON.parse(result))
      end

      private

      # Make a request against the cancel endpoint from the API and return the
      # raw response. After getting the response back it's checked to see if
      # there are any API errors and raises the relevant one if there is.
      #
      # @param slevomat_id [Integer] a slevomat_id of order for the cancel request
      # @param params [Hash] a hash of parameters for the cancel request
      # @return [Faraday::Response] the raw response back from the connection
      def cancel_request(slevomat_id, params)
        path = PATH.sub(':slevomat_id', slevomat_id.to_s).sub(':endpoint_version', @client.endpoint_version)
        result = @client.connection.post path, params
        Error.check_for_error(result)
        result
      end
    end
  end
end
