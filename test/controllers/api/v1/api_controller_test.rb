require 'test_helper'

class Api::V1::ApiControllerTest < ActionController::TestCase
   test "the truth" do
     assert true
   end

  test "should not save System without data" do
    sys = System.new
    assert_not sys.save
  end
  
  #register
  test "register API call fails without params" do
    headers = { 'CONTENT_TYPE' => 'application/json' }
    json = '{"foo":"bar","boolean":true}'
    post :register, json, headers

    assert_equal "Missing params", response.body
  end

  test "register API call succeeds with correct params" do
    headers = { 'CONTENT_TYPE' => 'application/json' }
    json = '{"urn":"foo","os":"bar", "address": "baz"}'
    post :register, json, headers
    
    assert_equal "OK", response.body
  end

  #updateSystem

  #updateTask

#  test "task update notification should fail w/o params" do
#    post_via_redirect("/v1/task/1/notify", nil, nil)	
#  end

#  test "task update notification should fail without params" do
#    headers = { 'CONTENT_TYPE' => 'application/json' }
#    post :updateTask, "{}", headers
#
#    assert_equal "", response.body
#  end

#  test "task update notification should succeed with params" do
#    headers = { 'CONTENT_TYPE' => 'application/json' }
#    post :updateTask, "{}", headers
#
#    assert_equal "", response.body
#  end

  #updateInstalled

  #routing
  test "should route to article" do
    assert_routing '/systems/1', { controller: "systems", action: "show", id: "1" }
  end
end
