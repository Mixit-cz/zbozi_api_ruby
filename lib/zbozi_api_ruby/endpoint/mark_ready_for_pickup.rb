require 'json'

require 'zbozi_api_ruby/responses/mark_ready_for_pickup'

module ZboziApiRuby
  module Endpoint
    class MarkReadyForPickup
      PATH = 'zbozi-api/:endpoint_version/order/:slevomat_id/mark-ready-for-pickup'

      def initialize(client)
        @client = client
      end

      # Take a mark_ready_for_pickup_request and return the response from the API
      #
      # @param slevomat_id [Integer] a slevomat_id of the order
      # @param params [Hash] a hash that corresponds to params of the API:
      #   https://www.slevomat.cz/partner/zbozi-api#pripraveno-k-osobnimu-odberu
      # @return [Response::MarkReadyForPickup] object of the response
      # @example Mark order getting ready for pickup with slevomat_id
      #   response = client.mark_ready_for_pickup(12345)
      # @example Mark order getting ready for pickup with slevomat_id and with params
      #   params = {
      #     "autoMarkDelivered": true
      #   }
      #
      #   response = client.mark_ready_for_pickup(12345, params)
      def mark_ready_for_pickup(slevomat_id, params = {})
        result = mark_ready_for_pickup_request(slevomat_id, params).body
        result = "{}" if result == ""
        Response::MarkReadyForPickup.new(JSON.parse(result))
      end

      private

      # Make a request against the mark_ready_for_pickup endpoint from the API and return the
      # raw response. After getting the response back it's checked to see if
      # there are any API errors and raises the relevant one if there is.
      #
      # @param slevomat_id [Integer] a slevomat_id of order for the mark_ready_for_pickup request
      # @param params [Hash] a hash of parameters for the mark_ready_for_pickup request
      # @return [Faraday::Response] the raw response back from the connection
      def mark_ready_for_pickup_request(slevomat_id, params)
        path = PATH.sub(':slevomat_id', slevomat_id.to_s).sub(':endpoint_version', @client.endpoint_version)
        result = @client.connection.post path, params
        Error.check_for_error(result)
        result
      end
    end
  end
end
