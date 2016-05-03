# a single server node where an agent is installed
class System < ActiveRecord::Base
  belongs_to :system_group
  has_many :concrete_package_versions

  has_many :package_versions, -> { distinct }, through: :concrete_package_versions
  has_many :packages, -> { distinct }, through: :package_versions

  validates_presence_of :urn
end
