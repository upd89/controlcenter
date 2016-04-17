# A collection of tasks, triggered by a single user's action
class Job < ActiveRecord::Base
  belongs_to :user
  has_many :tasks
end
