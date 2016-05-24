class PackageAssignmentController < ApplicationController
  def index
    @packages = Package.all.reject{|pkg| !pkg.group_assignments.empty?}
  end
end
