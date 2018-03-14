require "test_helper"

class Client < Minitest::Test
  def setup
    @test_auth_keys = {token: 'token', api_secret: 'api_secret', test: true}
    @auth_keys = {token: 'token', api_secret: 'api_secret'}
    @invalid_auth_keys = {token: 'token'}
  end

  def test_that_it_fails_with_missing_api_keys
    assert_raises(ZboziApiRuby::Error::MissingAPIKeys) {
      ZboziApiRuby::Client.new(@invalid_auth_keys)
    }
  end

  def test_that_its_connection_fails_with_no_config
    client = ZboziApiRuby::Client.new
    assert_raises(ZboziApiRuby::Error::MissingAPIKeys) {
      client.connection
    }
  end

  def test_that_it_initializes_with_correct_api_keys
    assert ZboziApiRuby::Client.new(@auth_keys)
  end

  def test_that_its_config_is_correct
    client = ZboziApiRuby::Client.new(@auth_keys)
    assert_kind_of ZboziApiRuby::Configuration, client.configuration
  end

  def test_that_its_not_configurable_after_init
    client =  ZboziApiRuby::Client.new(@test_auth_keys)
    assert_raises(ZboziApiRuby::Error::AlreadyConfigured) {
      client.configure do |config|
        config['token'] = 'new_token'
      end
    }
  end
end
