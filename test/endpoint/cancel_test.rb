require "test_helper"

class Cancel < Minitest::Test
  def test_it_runs_ok_with_correct_data
    VCR.use_cassette("cancel") do
      @auth_keys = {token: ENV['TOKEN'], api_secret: ENV['API_SECRET']}
      @client = ZboziApiRuby::Client.new(@auth_keys.merge(test: true))
      response = @client.cancel(1234, {items: [{slevomatId: '45454', amount: 15}]})
      assert_kind_of ZboziApiRuby::Response::Cancel, response
    end
  end

  def test_it_errors_with_incorrect_data
    VCR.use_cassette("cancel_error") do
      @auth_keys = {token: ENV['TOKEN'], api_secret: ENV['API_SECRET']}
      @client = ZboziApiRuby::Client.new(@auth_keys.merge(test: true))
      error = assert_raises ZboziApiRuby::Error::InvalidRequest do
        @client.cancel(1234)
      end
      assert_equal "Missing 'items' key in POST data.", error.message
    end
  end
end
