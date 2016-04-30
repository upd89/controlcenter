# a single server node where an agent is installed
class System < ActiveRecord::Base
  belongs_to :system_group
  has_many :concrete_package_versions

  validates_presence_of :urn
end
