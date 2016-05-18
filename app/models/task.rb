# a single order which is sent to an agent to install some updates
class Task < ActiveRecord::Base
  belongs_to :task_state
  belongs_to :task_execution
  belongs_to :job

  has_many :concrete_package_versions
  has_one :system, -> { distinct }, through: :concrete_package_versions

  filterrific(
    default_filter_params: {},
    available_filters: [
      :with_task_state_id
    ]
  )

  scope :with_task_state_id, lambda { |task_state_ids|
    where(:task_state_id => [*task_state_ids])
  }

  self.per_page = Settings.Pagination.NoOfEntriesPerPage
end
