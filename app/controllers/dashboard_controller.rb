class DashboardController < ApplicationController
  helper_method :get_running_tasks,
                :get_failed_tasks,
                :get_not_recently_seen_systems,
                :get_systems_without_group,
                :get_packages_without_group,
                :get_tasks_for_recent_activities,
                :get_overdue_tasks

  #load_and_authorize_resource

  # GET /dashboard
  def index
    cpv_state_avail = ConcretePackageState.where(name: "Available")[0]

    @systems = System.all
    @packages = Package.all
    @tasks = Task.all
    @updates = ConcretePackageVersion.where(concrete_package_state: cpv_state_avail)

    @updatable_systems = @systems.reject{ |s| s.get_installable_CPVs.count < 1 }
  end

  def get_running_tasks
    statePending = TaskState.where(name: "Pending")[0]
    @tasks.where(task_state: statePending)
  end

  def get_failed_tasks
    stateFailed = TaskState.where(name: "Failed")[0]
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

  def get_overdue_tasks
    pending = TaskState.where(name: "Pending")[0]
    queued = TaskState.where(name: "Queued")[0]

    @tasks.where( "created_at < ?", (Time.now - (Settings.Tasks.OverdueWarningThresholdMinutes).minutes ) ).where( task_state: [queued, pending ] )
  end
end
