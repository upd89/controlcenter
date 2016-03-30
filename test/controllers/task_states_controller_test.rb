require 'test_helper'

class TaskStatesControllerTest < ActionController::TestCase
  setup do
    @task_state = task_states(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:task_states)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task_state" do
    assert_difference('TaskState.count') do
      post :create, task_state: { name: @task_state.name }
    end

    assert_redirected_to task_state_path(assigns(:task_state))
  end

  test "should show task_state" do
    get :show, id: @task_state
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task_state
    assert_response :success
  end

  test "should update task_state" do
    patch :update, id: @task_state, task_state: { name: @task_state.name }
    assert_redirected_to task_state_path(assigns(:task_state))
  end

  test "should destroy task_state" do
    assert_difference('TaskState.count', -1) do
      delete :destroy, id: @task_state
    end

    assert_redirected_to task_states_path
  end
end
