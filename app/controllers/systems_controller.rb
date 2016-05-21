class SystemsController < ApplicationController
  before_action :set_system, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # GET /systems
  def index
    @filterrific = initialize_filterrific(
      System,
      params[:filterrific],
      :select_options => {
        sorted_by: System.options_for_sorted_by,
        with_system_group_id: SystemGroup.options_for_select
      }
    ) or return
    @systems = @filterrific.find.page(params[:page])
  end

  # GET /systems/1
  def show
    @recent_tasks = @system.tasks.order(:created_at ).reverse_order.limit(10)

    @filterrific_show = initialize_filterrific(
      ConcretePackageVersion.where(system: @system ),
      params[:filterrific],
      :select_options => {
        with_state_id: ConcretePackageState.options_for_select
      }
    ) or return
    @concrete_package_versions = @filterrific_show.find.page(params[:page])
    @installableCPVs = ConcretePackageVersion.where(system: @system, concrete_package_state: ConcretePackageState.where(name: "Available")[0] )
  end

  # POST /systems
  def create
    @system = System.new(system_params)

    if @system.save
      redirect_to @system, success: 'System was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /systems/1
  def update
    if @system.update(system_params)
      redirect_to @system, success: 'System was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /systems/1
  def destroy
    @system.destroy
    redirect_to systems_url, success: 'System was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system
      @system = System.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def system_params
      params.require(:system).permit(:name, :urn, :os, :reboot_required, :address, :last_seen, :system_group_id)
    end
end
