require 'json'

require 'zbozi_api_ruby/responses/mark_en_route'

module ZboziApiRuby
  module Endpoint
    class MarkEnRoute
      PATH = 'zbozi-api/:endpoint_version/order/:slevomat_id/mark-en-route'

      def initialize(client)
        @client = client
      end

      # Take a mark_en_route_request and return the response from the API
      #
      # @param slevomat_id [Integer] a slevomat_id of the order
      # @param params [Hash] a hash that corresponds to params of the API:
      #   https://www.slevomat.cz/partner/zbozi-api#na-ceste
      # @return [Response::MarkEnRoute] object of the response
      #   with expected_delivery_date
      # @example Mark order en route with slevomat_id and with params
      #   params = {
      #     "autoMarkDelivered": true
      #   }
      #
      #   response = client.mark_en_route(12345, params)
      def mark_en_route(slevomat_id, params = {})
        result = mark_en_route_request(slevomat_id, params).body
        Response::MarkEnRoute.new(JSON.parse(result))
      end

      private

      # Make a request against the mark_en_route endpoint from the API and return the
      # raw response. After getting the response back it's checked to see if
      # there are any API errors and raises the relevant one if there is.
      #
      # @param slevomat_id [Integer] a slevomat_id of order for the mark_en_route request
      # @param params [Hash] a hash of parameters for the mark_en_route request
      # @return [Faraday::Response] the raw response back from the connection
      def mark_en_route_request(slevomat_id, params)
        path = PATH.sub(':slevomat_id', slevomat_id.to_s).sub(':endpoint_version', @client.endpoint_version)
        result = @client.connection.post path, params
        Error.check_for_error(result)
        result
      end
    end
  end
end
