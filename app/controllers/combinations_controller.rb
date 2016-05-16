class CombinationsController < ApplicationController
  #load_and_authorize_resource

  # GET /combinations
  def index
    @filterrific = initialize_filterrific(
      Package,
      params[:filterrific],
      :select_options => {
        sorted_by: Package.options_for_sorted_by,
        with_package_group_id: PackageGroup.options_for_select
      }
    ) or return
    @packages = @filterrific.find.page(params[:page])

    @filterrific_systems = initialize_filterrific(
      System,
      params[:filterrific],
      :select_options => {
        sorted_by: System.options_for_sorted_by,
        with_system_group_id: SystemGroup.options_for_select
      }
    ) or return
    @systems = @filterrific_systems.find.page(params[:page])
  end
end
