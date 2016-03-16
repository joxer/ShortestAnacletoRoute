require 'test_helper'
require 'rome2rio'
class RouteTest < ActiveSupport::TestCase

  include Rome2Rio

  self.use_instantiated_fixtures = true

  test "search from a to b and put into database" do
      result = Tool.get_result_and_save_to_DB("Rome","London")
      assert_not_equal(result,nil)
      assert_not_equal(result.route_transports, [])
   end

   test "assert that doesn't exist a way from A to B" do
     result = Tool.get_result_and_save_to_DB("Trallallero","Trallallà")
     assert_equal(result,nil)
   end

   test "assert that multiple way exists" do
     result = Tool.get_result_and_save_to_DB("Rome","Milan")
     assert_not_equal(result.route_transports.length,1)
   end

   test "get Result from A an B" do
     result = Tool.get_result("Rome", "Milan")
     assert_not_equal(result[1],[])
   end

   test "get Result from A an B and should be empty" do
     result = Tool.get_result("Rome", "Nessunacittà")
     assert_equal(result[1],[])
   end

   test 'get Result from A and B and train should exist' do

     result = Tool.get_result("Rome", "Milan")
     assert_not_equal(JSON.parse(result[0].cache)["train"], {})
   end

   test 'see if avg method is correct!' do

    transports = routes(:RomeMilan).route_transports.all.map { |value| {duration: value.duration, price: value.price, type: value.route_type.to_sym} }.delete_if {|value| value[:type] == "else"}
    cache = JSON.parse(routes(:RomeMilan).cache, :symbolize_names => true)
    avg = Tool.calculate_media(transports)
    assert_equal(avg , cache)
   end
end
