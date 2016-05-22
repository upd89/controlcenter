class DashboardController < ApplicationController
  helper_method :get_running_tasks,
                :get_failed_tasks,
                :get_not_recently_seen_systems,
                :get_systems_without_group,
                :get_packages_without_group,
                :get_tasks_for_recent_activities

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
    @systems.where("last_seen > ?", (Time.now - (Settings.Systems.NotSeenWarningThresholdMinutes / 60).hours ) )
  end

  def get_systems_without_group
    unassigned = SystemGroup.where(name: "Unassigned-System")[0]
    @systems.where( system_group: [ nil, unassigned ] )
  end

  def get_packages_without_group
    @packages.reject{|pkg| !pkg.group_assignments.empty?}
  end

  def get_tasks_for_recent_activities
    @tasks.order(:created_at ).reverse_order.limit(Settings.Systems.NoOfShownRecentTasks)
  end
end
