class ConcretePackageVersionsController < ApplicationController
  before_action :set_concrete_package_version, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # GET /concrete_package_versions
  def index
    @filterrific = initialize_filterrific(
      ConcretePackageVersion,
      params[:filterrific],
      :select_options => {
        sorted_by: ConcretePackageVersion.options_for_sorted_by,
        with_state_id: ConcretePackageState.options_for_select
      }
    ) or return
    @concrete_package_versions = @filterrific.find.page(params[:page])
  end

  # POST /concrete_package_versions
  def create
    @concrete_package_version = ConcretePackageVersion.new(concrete_package_version_params)

    if @concrete_package_version.save
      redirect_to @concrete_package_version, success: 'Concrete package version was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /concrete_package_versions/1
  def update
    if @concrete_package_version.update(concrete_package_version_params)
      redirect_to @concrete_package_version, success: 'Concrete package version was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /concrete_package_versions/1
  def destroy
    @concrete_package_version.destroy
    redirect_to concrete_package_versions_url, success: 'Concrete package version was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_concrete_package_version
      @concrete_package_version = ConcretePackageVersion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concrete_package_version_params
      params.require(:concrete_package_version).permit(:system_id, :task_id, :concrete_package_state_id, :package_version_id)
    end
end
