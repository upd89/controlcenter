class SystemUpdateStatesController < ApplicationController
  before_action :set_system_update_state, only: [:show, :edit, :update, :destroy]

  # GET /system_update_states
  # GET /system_update_states.json
  def index
    @system_update_states = SystemUpdateState.all
  end

  # GET /system_update_states/1
  # GET /system_update_states/1.json
  def show
  end

  # GET /system_update_states/new
  def new
    @system_update_state = SystemUpdateState.new
  end

  # GET /system_update_states/1/edit
  def edit
  end

  # POST /system_update_states
  # POST /system_update_states.json
  def create
    @system_update_state = SystemUpdateState.new(system_update_state_params)

    respond_to do |format|
      if @system_update_state.save
        format.html { redirect_to @system_update_state, notice: 'System update state was successfully created.' }
        format.json { render :show, status: :created, location: @system_update_state }
      else
        format.html { render :new }
        format.json { render json: @system_update_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /system_update_states/1
  # PATCH/PUT /system_update_states/1.json
  def update
    respond_to do |format|
      if @system_update_state.update(system_update_state_params)
        format.html { redirect_to @system_update_state, notice: 'System update state was successfully updated.' }
        format.json { render :show, status: :ok, location: @system_update_state }
      else
        format.html { render :edit }
        format.json { render json: @system_update_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /system_update_states/1
  # DELETE /system_update_states/1.json
  def destroy
    @system_update_state.destroy
    respond_to do |format|
      format.html { redirect_to system_update_states_url, notice: 'System update state was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_update_state
      @system_update_state = SystemUpdateState.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def system_update_state_params
      params.require(:system_update_state).permit(:name)
    end
end
