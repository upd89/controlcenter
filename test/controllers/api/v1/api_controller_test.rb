require 'test_helper'

class Api::V1::ApiControllerTest < ActionController::TestCase
   test "the truth" do
     assert true
   end

  test "should not save System without data" do
    sys = System.new
    assert_not sys.save
  end
end
