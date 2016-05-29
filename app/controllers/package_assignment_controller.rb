class PackageAssignmentController < ApplicationController
  def index
    @packages = Package.all.reject{|pkg| !pkg.group_assignments.empty?}
  end

  def add_to_groups

  end
end
