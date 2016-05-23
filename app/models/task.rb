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

  def decorated_created_at
    created_at.to_formatted_s(:short)
  end

  def to_full_sentence
    decorated_created_at + ": " + job.user.name + " created Task " + id.to_s + " with " + concrete_package_versions.length.to_s + " Updates" + (concrete_package_versions.count > 0 ? " for " + concrete_package_versions.first.system.name : "")
  end

  def state_description
    case task_state
      when TaskState.where(name: "Pending")[0]
        ", is still going on."
      when TaskState.where(name: "Not Delivered")[0]
        ", which wasn't delivered."
      when TaskState.where(name: "Queued")[0]
        ", which is queued."
      when TaskState.where(name: "Failed")[0]
        ", which failed."
      when TaskState.where(name: "Done")[0]
        ", which succeeded!"
      else
        "."
    end
  end

  self.per_page = Settings.Pagination.NoOfEntriesPerPage
end
