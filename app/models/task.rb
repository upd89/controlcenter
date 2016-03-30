class Task < ActiveRecord::Base
  belongs_to :task_state
  belongs_to :task_execution
  belongs_to :job
end
