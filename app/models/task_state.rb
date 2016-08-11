class TaskState < ActiveRecord::Base
  validates :name, presence: true

  def self.options_for_select
    order("LOWER(name)").map {|e| [e.name, e.id] }
  end
end
