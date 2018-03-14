require "test_helper"

class MarkEnRoute < Minitest::Test
  def test_it_runs_ok_with_correct_data
    VCR.use_cassette("mark_en_route") do
      @auth_keys = {token: ENV['TOKEN'], api_secret: ENV['API_SECRET']}
      @client = ZboziApiRuby::Client.new(@auth_keys.merge(test: true))
      response = @client.mark_en_route(1234, {autoMarkDelivered: true})
      assert_kind_of ZboziApiRuby::Response::MarkEnRoute, response
      assert_equal "2018-03-15", response.expected_delivery_date
    end
  end

  def test_it_errors_with_incorrect_data
    VCR.use_cassette("mark_en_route_invalid_request") do
      @auth_keys = {token: ENV['TOKEN'], api_secret: ENV['API_SECRET']}
      @client = ZboziApiRuby::Client.new(@auth_keys.merge(test: true))
      error = assert_raises ZboziApiRuby::Error::InvalidRequest do
        @client.mark_en_route(1234)
      end
      assert "Missing 'autoMarkDelivered' key in POST data.", error.message
    end
  end
end
