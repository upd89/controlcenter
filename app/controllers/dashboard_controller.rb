class DashboardController < ApplicationController
  helper_method :get_running_tasks,
                :get_failed_tasks,
                :get_not_recently_seen_systems,
                :get_systems_without_group,
                :get_packages_without_group

  #load_and_authorize_resource

  # GET /dashboard
  def index
    @systems = System.all
    @packages = Package.all
    @tasks = Task.all
  end

  def get_running_tasks
    statePending = TaskState.where(name: "Pending")
    @tasks.where(task_state: statePending)
  end

  def get_failed_tasks
    stateFailed = TaskState.where(name: "Failed")
    @tasks.where(task_state: stateFailed)
  end

  def get_not_recently_seen_systems
    @systems.where("last_seen > ?", (Time.now - 4.hours ) )
  end

  def get_systems_without_group
    @systems.where( system_group: nil )
  end

  def get_packages_without_group
    @packages.reject{|pkg| !pkg.group_assignments.empty?}
  end
end
