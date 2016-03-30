require 'test_helper'

class PackageGroupsControllerTest < ActionController::TestCase
  setup do
    @package_group = package_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:package_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create package_group" do
    assert_difference('PackageGroup.count') do
      post :create, package_group: { name: @package_group.name, permission_level: @package_group.permission_level }
    end

    assert_redirected_to package_group_path(assigns(:package_group))
  end

  test "should show package_group" do
    get :show, id: @package_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @package_group
    assert_response :success
  end

  test "should update package_group" do
    patch :update, id: @package_group, package_group: { name: @package_group.name, permission_level: @package_group.permission_level }
    assert_redirected_to package_group_path(assigns(:package_group))
  end

  test "should destroy package_group" do
    assert_difference('PackageGroup.count', -1) do
      delete :destroy, id: @package_group
    end

    assert_redirected_to package_groups_path
  end
end
