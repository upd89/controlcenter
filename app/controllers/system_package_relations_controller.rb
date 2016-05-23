class SystemPackageRelationsController < ApplicationController

  # GET /system_package_relations
  def index
    @filterrific = initialize_filterrific(
      SystemPackageRelationGrouped,
      params[:filterrific],
      select_options: {
        sorted_by: SystemPackageRelationGrouped.options_for_sorted_by,
        with_system_group_id: SystemGroup.options_for_select,
        with_package_group_id: PackageGroup.options_for_select
      }
    ) or return

    @system_package_relations = @filterrific.find.page(params[:page])

    # @filterrific = initialize_filterrific(
    #   Package,
    #   params[:filterrific],
    #   :select_options => {
    #     sorted_by: Package.options_for_sorted_by,
    #     with_package_group_id: PackageGroup.options_for_select
    #   }
    # ) or return
    # @packages = @filterrific.find.page(params[:page])
    #
    # @filterrific_systems = initialize_filterrific(
    #   System,
    #   params[:filterrific],
    #   :select_options => {
    #     sorted_by: System.options_for_sorted_by,
    #     with_system_group_id: SystemGroup.options_for_select
    #   }
    # ) or return
    # @systems = @filterrific_systems.find.page(params[:page])
    #
    # allSystemPackageRelations = SystemPackageRelation.all
    # @system_package_relations = {}
    # allSystemPackageRelations.each do |p|
    #   if @system_package_relations[p.pkg_id]
    #     @system_package_relations[p.pkg_id].increment()
    #   else
    #     @system_package_relations[p.pkg_id] = Pkg.new(p.pkg_id, p.pkg_name, p.pkg_section)
    #   end
    # end
  end


  # GET /system_package_relations/id
  def show
    @system_package_relations = SystemPackageRelation.where(:pkg_id => params['id'])
  end
end
