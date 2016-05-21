# A collection of tasks, triggered by a single user's action
class Job < ActiveRecord::Base
  belongs_to :user
  has_many :tasks

  def decorated_started_at
      started_at.to_formatted_s(:short)
  end
end
