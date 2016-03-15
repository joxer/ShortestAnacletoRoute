require 'test/unit'
require_relative '../rome2rio/rome2rio'

class TestRome2Rio < Test::Unit::TestCase
  def test_work
    result = Rome2Rio.get_from_a_to_b("Lecce", "Bari")
    assert_not_nil(result)
  end

  def test_result_consistent
    result = Rome2Rio.get_from_a_to_b("Rome", "Milan")

    assert_equal(result.start["name"], "Rome")
    assert_equal(result.end["name"],"Milan")
  end

  def test_route_exist
    result = Rome2Rio.get_from_a_to_b("Rome", "Milan")
    assert_not_equal(result.transports,[])
  end

  def test_route_not_exist
    result = Rome2Rio.get_from_a_to_b("Nalalala", "Kalalala") #two dummiees city
    assert_equal(result.empty?,true)
  end
end
