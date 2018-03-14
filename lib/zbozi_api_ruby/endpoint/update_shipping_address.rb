require 'json'

require 'zbozi_api_ruby/responses/update_shipping_address'

module ZboziApiRuby
  module Endpoint
    class UpdateShippingAddress
      PATH = 'zbozi-api/:endpoint_version/order/:slevomat_id/update-shipping-address'

      def initialize(client)
        @client = client
      end

      # Take a update_shipping_address_request and return the response from the API
      #
      # @param slevomat_id [Integer] a slevomat_id of the order
      # @param params [Hash] a hash that corresponds to params of the API:
      #   https://www.slevomat.cz/partner/zbozi-api#zmena-dorucovaci-adresy
      # @return [Response::UpdateShippingAddress] object of the response
      #   contains no data
      # @example Update shipping address with slevomat_id and with params
      #   params = {
      #      name: "Karel Novák",
      #      street: "Pod horou 34",
      #      city: "Pardubice",
      #      zipCode: "53000",
      #      state: "CZ",
      #      phone: "+420777888999",
      #      company: "Knihkupectví Novák"
      #   }
      #
      #   response = client.update_shipping_address(12345, params)
      def update_shipping_address(slevomat_id, params = {})
        result = update_shipping_address_request(slevomat_id, params).body
        result = "{}" if result == ""
        Response::UpdateShippingAddress.new(JSON.parse(result))
      end

      private

      # Make a request against the update_shipping_address endpoint from the API and return the
      # raw response. After getting the response back it's checked to see if
      # there are any API errors and raises the relevant one if there is.
      #
      # @param slevomat_id [Integer] a slevomat_id of order for the update_shipping_address request
      # @param params [Hash] a hash of parameters for the update_shipping_address request
      # @return [Faraday::Response] the raw response back from the connection
      def update_shipping_address_request(slevomat_id, params)
        path = PATH.sub(':slevomat_id', slevomat_id.to_s).sub(':endpoint_version', @client.endpoint_version)
        result = @client.connection.post path, params
        Error.check_for_error(result)
        result
      end
    end
  end
end
