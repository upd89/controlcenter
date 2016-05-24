class SystemAssignmentController < ApplicationController
  def index
    unassigned = SystemGroup.where(name: "Unassigned-System")[0]
    @systems = System.where( system_group: [ nil, unassigned ] )
  end
end
