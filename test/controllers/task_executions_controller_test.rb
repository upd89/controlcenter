require 'test_helper'

class TaskExecutionsControllerTest < ActionController::TestCase
  setup do
    @task_execution = task_executions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:task_executions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task_execution" do
    assert_difference('TaskExecution.count') do
      post :create, task_execution: { log: @task_execution.log }
    end

    assert_redirected_to task_execution_path(assigns(:task_execution))
  end

  test "should show task_execution" do
    get :show, id: @task_execution
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task_execution
    assert_response :success
  end

  test "should update task_execution" do
    patch :update, id: @task_execution, task_execution: { log: @task_execution.log }
    assert_redirected_to task_execution_path(assigns(:task_execution))
  end

  test "should destroy task_execution" do
    assert_difference('TaskExecution.count', -1) do
      delete :destroy, id: @task_execution
    end

    assert_redirected_to task_executions_path
  end
end
