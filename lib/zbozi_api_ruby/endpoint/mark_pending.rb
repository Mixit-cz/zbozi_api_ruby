require 'json'

require 'zbozi_api_ruby/responses/mark_pending'

module ZboziApiRuby
  module Endpoint
    class MarkPending
      PATH = 'zbozi-api/:endpoint_version/order/:slevomat_id/mark-pending'

      def initialize(client)
        @client = client
      end

      # Take a mark_pending_request and return the response from the API
      #
      # @param slevomat_id [Integer] a slevomat_id of the order
      #   https://www.slevomat.cz/partner/zbozi-api#vyrizuje-se
      # @return [Response::MarkPending] object of the response
      #   does not contain anything
      #
      # @example MarkPending order with slevomat_id
      #
      #   response = client.mark_pending(12345)
      def mark_pending(slevomat_id)
        result = mark_pending_request(slevomat_id).body
        result = "{}" if result == ""
        Response::MarkPending.new(JSON.parse(result))
      end

      private

      # Make a request against the mark_pending endpoint from the API and return the
      # raw response. After getting the response back it's checked to see if
      # there are any API errors and raises the relevant one if there is.
      #
      # @param slevomat_id [Integer] a slevomat_id of order for the mark_pending request
      # @return [Faraday::Response] the raw response back from the connection
      def mark_pending_request(slevomat_id)
        path = PATH.sub(':slevomat_id', slevomat_id.to_s).sub(':endpoint_version', @client.endpoint_version)
        result = @client.connection.post path, {}
        Error.check_for_error(result)
        result
      end
    end
  end
end
