class PackageGroup < ActiveRecord::Base
  has_many :group_assignments
  has_many :packages, -> { distinct }, through: :group_assignments, :dependent => :restrict_with_error

  validates_presence_of :name
end
