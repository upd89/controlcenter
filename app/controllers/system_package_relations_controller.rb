class SystemPackageRelationsController < ApplicationController
  # GET /systems
  def index
    @system_package_relations = SystemPackageRelation.all
  end
end
