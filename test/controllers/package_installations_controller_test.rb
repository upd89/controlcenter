require 'test_helper'

class PackageInstallationsControllerTest < ActionController::TestCase
  setup do
    @package_installation = package_installations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:package_installations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create package_installation" do
    assert_difference('PackageInstallation.count') do
      post :create, package_installation: { installed_version: @package_installation.installed_version, package_id: @package_installation.package_id, system_id: @package_installation.system_id }
    end

    assert_redirected_to package_installation_path(assigns(:package_installation))
  end

  test "should show package_installation" do
    get :show, id: @package_installation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @package_installation
    assert_response :success
  end

  test "should update package_installation" do
    patch :update, id: @package_installation, package_installation: { installed_version: @package_installation.installed_version, package_id: @package_installation.package_id, system_id: @package_installation.system_id }
    assert_redirected_to package_installation_path(assigns(:package_installation))
  end

  test "should destroy package_installation" do
    assert_difference('PackageInstallation.count', -1) do
      delete :destroy, id: @package_installation
    end

    assert_redirected_to package_installations_path
  end
end
