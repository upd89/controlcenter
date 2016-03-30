require 'test_helper'

class SystemUpdatesControllerTest < ActionController::TestCase
  setup do
    @system_update = system_updates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:system_updates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create system_update" do
    assert_difference('SystemUpdate.count') do
      post :create, system_update: { package_update_id: @system_update.package_update_id, system_id: @system_update.system_id, system_update_state_id: @system_update.system_update_state_id, task_id: @system_update.task_id }
    end

    assert_redirected_to system_update_path(assigns(:system_update))
  end

  test "should show system_update" do
    get :show, id: @system_update
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @system_update
    assert_response :success
  end

  test "should update system_update" do
    patch :update, id: @system_update, system_update: { package_update_id: @system_update.package_update_id, system_id: @system_update.system_id, system_update_state_id: @system_update.system_update_state_id, task_id: @system_update.task_id }
    assert_redirected_to system_update_path(assigns(:system_update))
  end

  test "should destroy system_update" do
    assert_difference('SystemUpdate.count', -1) do
      delete :destroy, id: @system_update
    end

    assert_redirected_to system_updates_path
  end
end
