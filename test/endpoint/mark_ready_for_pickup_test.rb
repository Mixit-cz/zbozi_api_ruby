require "test_helper"

class MarkReadyForPickup < Minitest::Test
  def test_it_runs_ok_with_correct_data
    VCR.use_cassette("mark_ready_for_pickup") do
      @auth_keys = {token: ENV['TOKEN'], api_secret: ENV['API_SECRET']}
      @client = ZboziApiRuby::Client.new(@auth_keys.merge(test: true))
      response = @client.mark_ready_for_pickup(1234, {autoMarkDelivered: true})
      assert_kind_of ZboziApiRuby::Response::MarkReadyForPickup, response
    end
  end

  def test_it_runs_ok_with_no_params
    VCR.use_cassette("mark_ready_for_pickup_no_params") do
      @auth_keys = {token: ENV['TOKEN'], api_secret: ENV['API_SECRET']}
      @client = ZboziApiRuby::Client.new(@auth_keys.merge(test: true))
      response = @client.mark_ready_for_pickup(1234)
      assert_kind_of ZboziApiRuby::Response::MarkReadyForPickup, response
    end
  end
end
