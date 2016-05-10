class TaskExecutionsController < ApplicationController
  before_action :set_task_execution, only: [:show, :edit, :update, :destroy]

  # GET /task_executions
  # GET /task_executions.json
  def index
    @task_executions = TaskExecution.all
    @paginated_task_executions = @task_executions.paginate(:page => params[:page], :per_page => Settings.Pagination.NoOfEntriesPerPage)

  end

  # GET /task_executions/1
  # GET /task_executions/1.json
  def show
  end

  # GET /task_executions/new
  def new
    @task_execution = TaskExecution.new
  end

  # GET /task_executions/1/edit
  def edit
  end

  # POST /task_executions
  # POST /task_executions.json
  def create
    @task_execution = TaskExecution.new(task_execution_params)

    respond_to do |format|
      if @task_execution.save
        format.html { redirect_to @task_execution, success: 'Task execution was successfully created.' }
        format.json { render :show, status: :created, location: @task_execution }
      else
        format.html { render :new }
        format.json { render json: @task_execution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_executions/1
  # PATCH/PUT /task_executions/1.json
  def update
    respond_to do |format|
      if @task_execution.update(task_execution_params)
        format.html { redirect_to @task_execution, success: 'Task execution was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_execution }
      else
        format.html { render :edit }
        format.json { render json: @task_execution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_executions/1
  # DELETE /task_executions/1.json
  def destroy
    @task_execution.destroy
    respond_to do |format|
      format.html { redirect_to task_executions_url, success: 'Task execution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_execution
      @task_execution = TaskExecution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_execution_params
      params.require(:task_execution).permit(:log)
    end
end
