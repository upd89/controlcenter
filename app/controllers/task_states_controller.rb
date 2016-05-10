class TaskStatesController < ApplicationController
  before_action :set_task_state, only: [:show, :edit, :update, :destroy]

  # GET /task_states
  # GET /task_states.json
  def index
    @task_states = TaskState.all
  end

  # GET /task_states/1
  # GET /task_states/1.json
  def show
  end

  # GET /task_states/new
  def new
    @task_state = TaskState.new
  end

  # GET /task_states/1/edit
  def edit
  end

  # POST /task_states
  # POST /task_states.json
  def create
    @task_state = TaskState.new(task_state_params)

    respond_to do |format|
      if @task_state.save
        format.html { redirect_to @task_state, success: 'Task state was successfully created.' }
        format.json { render :show, status: :created, location: @task_state }
      else
        format.html { render :new }
        format.json { render json: @task_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_states/1
  # PATCH/PUT /task_states/1.json
  def update
    respond_to do |format|
      if @task_state.update(task_state_params)
        format.html { redirect_to @task_state, success: 'Task state was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_state }
      else
        format.html { render :edit }
        format.json { render json: @task_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_states/1
  # DELETE /task_states/1.json
  def destroy
    @task_state.destroy
    respond_to do |format|
      format.html { redirect_to task_states_url, success: 'Task state was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_state
      @task_state = TaskState.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_state_params
      params.require(:task_state).permit(:name)
    end
end
