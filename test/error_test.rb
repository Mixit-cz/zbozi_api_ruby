require "test_helper"

class ErrorTest < Minitest::Test
  def setup
    @conn = Faraday.new do |connection|
      connection.adapter :test do |stub|
        stub.get('ok')        { [200, {'Content-Type' => 'text/json'}, '{}'] }
        stub.get('error')     { [422, {'Content-Type' => 'text/json'}, '{"status": 3,"messages": ["Order #1234 was not found."]}' ]}
      end
    end
  end

  def test_that_it_works_with_correct_response
    assert_nil ZboziApiRuby::Error::ResponseValidator.new.validate @conn.get('ok')
  end

  def test_it_raises_with_error_response
    error = assert_raises ZboziApiRuby::Error::NonExistentOrder do
      ZboziApiRuby::Error::ResponseValidator.new.validate @conn.get('error')
    end
    assert_equal 'Order #1234 was not found.', error.message
  end
end
