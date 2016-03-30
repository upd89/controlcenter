require 'test_helper'

class SystemUpdateStatesControllerTest < ActionController::TestCase
  setup do
    @system_update_state = system_update_states(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:system_update_states)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create system_update_state" do
    assert_difference('SystemUpdateState.count') do
      post :create, system_update_state: { name: @system_update_state.name }
    end

    assert_redirected_to system_update_state_path(assigns(:system_update_state))
  end

  test "should show system_update_state" do
    get :show, id: @system_update_state
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @system_update_state
    assert_response :success
  end

  test "should update system_update_state" do
    patch :update, id: @system_update_state, system_update_state: { name: @system_update_state.name }
    assert_redirected_to system_update_state_path(assigns(:system_update_state))
  end

  test "should destroy system_update_state" do
    assert_difference('SystemUpdateState.count', -1) do
      delete :destroy, id: @system_update_state
    end

    assert_redirected_to system_update_states_path
  end
end
