class AjaxController < ActionController::Base
    helper_method :get_running_tasks,
                    :sys_count,
                    :get_tasks_for_recent_activities,
                    :get_overdue_tasks,
                    :get_systems_with_queued_updates,
                    :get_systems_without_updates_or_queued,
                    :get_systems_with_available_updates_only

    # GET /update-data
    def update_data
        respond_to :json

        cpv_state_avail = ConcretePackageState.where(name: "Available")[0]

        @updates = ConcretePackageVersion.where(concrete_package_state: cpv_state_avail)

        @updatable_systems = System.all.reject{ |s| s.get_installable_CPVs.count < 1 }
        @updatable_system_groups = SystemGroup.all.reject{ |g| !g.has_installable_CPVs }
    end

    def sys_count
        System.all.count
    end

    def get_tasks_for_recent_activities
        Task.all
            .order(:created_at )
            .reverse_order
            .limit(Settings.Systems.NoOfShownRecentTasks)
    end

    def get_overdue_tasks
        pending = TaskState.where(name: "Pending")[0]
        queued = TaskState.where(name: "Queued")[0]

        Task.all
            .where( "created_at < ?", (Time.now - (Settings.Tasks.OverdueWarningThresholdMinutes).minutes ) )
            .where( task_state: [queued, pending ] )
    end

    def get_systems_with_queued_updates
        System.all
              .reject{ |s| s.get_queued_CPVs.count == 0 }
    end

    def get_systems_without_updates_or_queued
        System.all
              .reject{ |s| s.get_queued_CPVs.count > 0 || s.get_installable_CPVs.count > 0 }
    end

    def get_systems_with_available_updates_only
        System.all
              .reject{ |s| s.get_installable_CPVs.count < 1 }
              .reject{ |s| s.get_queued_CPVs.count > 0 }
    end
end