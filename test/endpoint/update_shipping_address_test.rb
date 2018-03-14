require "test_helper"

class UpdateShippingAddress < Minitest::Test
  def test_it_runs_ok_with_correct_data
    VCR.use_cassette("update_shipping_address") do
      @auth_keys = {token: ENV['TOKEN'], api_secret: ENV['API_SECRET']}
      @client = ZboziApiRuby::Client.new(@auth_keys.merge(test: true))
      response = @client.update_shipping_address(1234, {
        name: "Karel Novák",
        street: "Pod horou 34",
        city: "Pardubice",
        postalCode: "53000",
        state: "CZ",
        phone: "+420777888999",
        company: "Knihkupectví Novák"
      })
      assert_kind_of ZboziApiRuby::Response::UpdateShippingAddress, response
    end
  end

  def test_it_runs_ok_with_no_company
    VCR.use_cassette("update_shipping_address_no_company") do
      @auth_keys = {token: ENV['TOKEN'], api_secret: ENV['API_SECRET']}
      @client = ZboziApiRuby::Client.new(@auth_keys.merge(test: true))
      response = @client.update_shipping_address(1234, {
        name: "Karel Novák",
        street: "Pod horou 34",
        city: "Pardubice",
        postalCode: "53000",
        state: "CZ",
        phone: "+420777888999"
      })
      assert_kind_of ZboziApiRuby::Response::UpdateShippingAddress, response
    end
  end

  def test_it_errors_with_incorrect_data
    VCR.use_cassette("update_shipping_address_no_data") do
      @auth_keys = {token: ENV['TOKEN'], api_secret: ENV['API_SECRET']}
      @client = ZboziApiRuby::Client.new(@auth_keys.merge(test: true))
      error = assert_raises ZboziApiRuby::Error::InvalidRequest do
        @client.update_shipping_address(1234, {})
      end
      assert "Missing 'name' key in POST data., Missing 'street' key in POST data., Missing 'city' key in POST data., Missing 'state' key in POST data., Missing 'phone' key in POST data., Missing 'postalCode' key in POST data.", error.message
    end
  end
end
