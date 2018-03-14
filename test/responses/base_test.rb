require "test_helper"

class Base < Minitest::Test
  def setup
    @json = {'expectedDeliveryDate' => '2018-01-01'}
  end

  def test_it_initializes_correctly
    assert ZboziApiRuby::Response::Base.new(@json)
  end

  def test_it_initializes_correct_snakecased_variables
    response = ZboziApiRuby::Response::Base.new(@json)
    assert_equal '2018-01-01', response.instance_variable_get(:@expected_delivery_date)
  end
end
