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


  # GET /systems
  def index
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

  # GET /systems/id
  def show
    @system_package_relations = SystemPackageRelation.where(:pkg_id => @system_package_relation)
  end

end
