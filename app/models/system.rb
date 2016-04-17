# a single server node where an agent is installed
class System < ActiveRecord::Base
  belongs_to :system_group
  has_many :system_updates

  validates_presence_of :urn
end
