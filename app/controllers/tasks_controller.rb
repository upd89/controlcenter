class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # GET /tasks
  def index
    @filterrific = initialize_filterrific(
      Task,
      params[:filterrific],
      :select_options => {
        sorted_by: Task.options_for_sorted_by,
        with_state_id: TaskState.options_for_select,
        with_system_id: System.options_for_select
      }
    ) or return
    @tasks = @filterrific.find.page(params[:page])
  end

  # GET /tasks/1
  def show
    @paginated_concrete_package_versions = @task.concrete_package_versions.paginate(:page => params[:page], :per_page => Settings.Pagination.NoOfEntriesPerPage)
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, success: 'Task was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task, success: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    if @task.task_state == TaskState.where(name: "Done")[0]
      next_state = ConcretePackageState.where(name: "Installed")[0]
    else
      next_state = ConcretePackageState.where(name: "Available")[0]
    end

    if @task.concrete_package_versions.length > 0
      prev_state = @task.concrete_package_versions.first().concrete_package_state
    else
      prev_state = ConcretePackageState.where(name: "Queued for Installation")[0]
    end

    @task.concrete_package_versions.each do |cpv|
      cpv.concrete_package_state = next_state
      cpv.concrete_package_state.save()
    end

    if @task.job && @task.job.tasks.length == 1
      @task.job.destroy()
    end

    if @task.destroy
      redirect_to tasks_url, success: 'Task was successfully destroyed.'
    else
      @task.concrete_package_versions.each do |cpv|
        cpv.concrete_package_state = prev_state
      end
      redirect_to tasks_url, error: 'Couldn\t delete task.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:task_state_id, :task_execution_id, :job_id, :system_id)
    end
end
