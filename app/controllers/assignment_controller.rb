class AssignmentController < ApplicationController
  def index
    unassigned = SystemGroup.where(name: "Unassigned-System")[0]
    @systems = System.where( system_group: [ nil, unassigned ] )
    @packages = Package.all.reject{|pkg| !pkg.group_assignments.empty?}
  end
end
