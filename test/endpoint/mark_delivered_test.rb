require "test_helper"

class MarkDelivered < Minitest::Test
  def test_it_runs_ok_with_correct_data
    VCR.use_cassette("mark_delivered") do
      @auth_keys = {token: ENV['TOKEN'], api_secret: ENV['API_SECRET']}
      @client = ZboziApiRuby::Client.new(@auth_keys.merge(test: true))
      response = @client.mark_delivered(1234)
      assert_kind_of ZboziApiRuby::Response::MarkDelivered, response
    end
  end
end
