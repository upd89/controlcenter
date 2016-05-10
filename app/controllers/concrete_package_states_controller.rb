class ConcretePackageStatesController < ApplicationController
  before_action :set_concrete_package_state, only: [:show, :edit, :update, :destroy]

  # GET /concrete_package_states
  # GET /concrete_package_states.json
  def index
    @concrete_package_states = ConcretePackageState.all
  end

  # GET /concrete_package_states/1
  # GET /concrete_package_states/1.json
  def show
  end

  # GET /concrete_package_states/new
  def new
    @concrete_package_state = ConcretePackageState.new
  end

  # GET /concrete_package_states/1/edit
  def edit
  end

  # POST /concrete_package_states
  # POST /concrete_package_states.json
  def create
    @concrete_package_state = ConcretePackageState.new(concrete_package_state_params)

    respond_to do |format|
      if @concrete_package_state.save
        format.html { redirect_to @concrete_package_state, success: 'Concrete package state was successfully created.' }
        format.json { render :show, status: :created, location: @concrete_package_state }
      else
        format.html { render :new }
        format.json { render json: @concrete_package_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /concrete_package_states/1
  # PATCH/PUT /concrete_package_states/1.json
  def update
    respond_to do |format|
      if @concrete_package_state.update(concrete_package_state_params)
        format.html { redirect_to @concrete_package_state, success: 'Concrete package state was successfully updated.' }
        format.json { render :show, status: :ok, location: @concrete_package_state }
      else
        format.html { render :edit }
        format.json { render json: @concrete_package_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /concrete_package_states/1
  # DELETE /concrete_package_states/1.json
  def destroy
    @concrete_package_state.destroy
    respond_to do |format|
      format.html { redirect_to concrete_package_states_url, success: 'Concrete package state was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_concrete_package_state
      @concrete_package_state = ConcretePackageState.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concrete_package_state_params
      params.require(:concrete_package_state).permit(:name)
    end
end
