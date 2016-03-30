require 'test_helper'

class SystemGroupsControllerTest < ActionController::TestCase
  setup do
    @system_group = system_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:system_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create system_group" do
    assert_difference('SystemGroup.count') do
      post :create, system_group: { name: @system_group.name, permission_level: @system_group.permission_level }
    end

    assert_redirected_to system_group_path(assigns(:system_group))
  end

  test "should show system_group" do
    get :show, id: @system_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @system_group
    assert_response :success
  end

  test "should update system_group" do
    patch :update, id: @system_group, system_group: { name: @system_group.name, permission_level: @system_group.permission_level }
    assert_redirected_to system_group_path(assigns(:system_group))
  end

  test "should destroy system_group" do
    assert_difference('SystemGroup.count', -1) do
      delete :destroy, id: @system_group
    end

    assert_redirected_to system_groups_path
  end
end
