require "test_helper"

class Configuration < Minitest::Test
  def setup
    @auth_keys = {token: 'token', api_secret: 'api_secret'}
    @test_config = ZboziApiRuby::Configuration.new(@auth_keys.merge(test: true))
    @config = ZboziApiRuby::Configuration.new(@auth_keys)

    @invalid_auth_keys = {token: 'token'}
    @invalid_config = ZboziApiRuby::Configuration.new(@invalid_auth_keys)
    @invalid_auth_keys_1 = {token: 'token', api_secret: ''}
    @invalid_config_1 = ZboziApiRuby::Configuration.new(@invalid_auth_keys_1)
    @invalid_auth_keys_2 = {token: 'token', api_secret: nil}
    @invalid_config_2 = ZboziApiRuby::Configuration.new(@invalid_auth_keys_2)
  end

  def test_that_it_correctly_initializes_with_test_endpoint
    assert @test_config.valid?
    assert @test_config.is_test?
    assert_equal @test_config.auth_keys, @auth_keys
  end

  def test_that_it_correctly_initializes_with_not_test_endpoint
    assert @config.valid?
    assert !@config.is_test?
    assert_equal @config.auth_keys, @auth_keys
  end

  def test_invalid_auth_keys
    assert !@invalid_config.valid?
  end

  def test_invalid_auth_keys_1
    assert !@invalid_config_1.valid?
  end

  def test_invalid_auth_keys_2
    assert !@invalid_config_2.valid?
  end
end
