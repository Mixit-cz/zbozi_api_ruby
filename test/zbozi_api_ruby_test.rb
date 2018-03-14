require "test_helper"

class ZboziApiRubyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ZboziApiRuby::VERSION
  end

  def test_it_is_correct_kind_and_initially_uncofigured
    assert_kind_of ::ZboziApiRuby::Client, ZboziApiRuby.client
    assert_nil ZboziApiRuby.client.configuration
  end
end
