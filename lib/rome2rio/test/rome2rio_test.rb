require 'test/unit'
require_relative '../rome2rio'

class TestRome2Rio < Test::Unit::TestCase


  def setup
    @instance = Rome2Rio.new
  end

  def test_work
    result = @instance.get_from_a_to_b("Lecce", "Bari")
    assert_not_nil(result)
  end

  def test_result_consistent
    result = @instance.get_from_a_to_b("Rome", "Milan")

    assert_equal(result.start["name"], "Rome")
    assert_equal(result.end["name"],"Milan")
  end

  def test_route_exist
    result = @instance.get_from_a_to_b("Rome", "Milan")
    assert_not_equal(result.transports,[])
  end

  def test_route_not_exist
    result = @instance.get_from_a_to_b("Nalalala", "Kalalala") #two dummiees city
    assert_equal(result.empty?,true)
  end

end
