class SystemPackageRelationsController < ApplicationController

  class Pkg
    attr_reader :pkg_id
    attr_reader :pkg_name
    attr_reader :pkg_section
    attr_reader :count

    def initialize(id, name, section)
      @pkg_id = id
      @pkg_name = name
      @pkg_section = section
      @count = 1
    end

    def to_s
      "#{pkg_id}, #{pkg_name}, #{pkg_name}"
    end

    def increment()
      @count += 1
    end

  end


  # GET /system_package_relations
  def index
    @filterrific = initialize_filterrific(
      Package,
      params[:filterrific],
      :select_options => {
        sorted_by: Package.options_for_sorted_by,
        with_package_group_id: PackageGroup.options_for_select
      }
    ) or return

    @filterrific_systems = initialize_filterrific(
      System,
      params[:filterrific],
      :select_options => {
        sorted_by: System.options_for_sorted_by,
        with_system_group_id: SystemGroup.options_for_select
      }
    ) or return

    allSystemPackageRelations = SystemPackageRelation.all
    @system_package_relations = {}
    allSystemPackageRelations.each do |p|
      if @system_package_relations[p.pkg_id]
        @system_package_relations[p.pkg_id].increment()
      else
        @system_package_relations[p.pkg_id] = Pkg.new(p.pkg_id, p.pkg_name, p.pkg_section)
      end
    end
  end

  # GET /system_package_relations/id
  def show
    @system_package_relations = SystemPackageRelation.where(:pkg_id => @system_package_relation)
  end

end
