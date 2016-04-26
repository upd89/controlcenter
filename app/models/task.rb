# a single order which is sent to an agent to install some updates
class Task < ActiveRecord::Base
  belongs_to :task_state
  belongs_to :task_execution
  belongs_to :job

  has_many :system_updates
end
