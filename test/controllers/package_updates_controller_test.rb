require 'test_helper'

class PackageUpdatesControllerTest < ActionController::TestCase
  setup do
    @package_update = package_updates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:package_updates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create package_update" do
    assert_difference('PackageUpdate.count') do
      post :create, package_update: { candidate_version: @package_update.candidate_version, package_id: @package_update.package_id, repository: @package_update.repository }
    end

    assert_redirected_to package_update_path(assigns(:package_update))
  end

  test "should show package_update" do
    get :show, id: @package_update
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @package_update
    assert_response :success
  end

  test "should update package_update" do
    patch :update, id: @package_update, package_update: { candidate_version: @package_update.candidate_version, package_id: @package_update.package_id, repository: @package_update.repository }
    assert_redirected_to package_update_path(assigns(:package_update))
  end

  test "should destroy package_update" do
    assert_difference('PackageUpdate.count', -1) do
      delete :destroy, id: @package_update
    end

    assert_redirected_to package_updates_path
  end
end
