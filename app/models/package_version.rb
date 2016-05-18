class PackageVersion < ActiveRecord::Base
  belongs_to :package
  belongs_to :distribution
  belongs_to :repository

  has_many :concrete_package_versions

  belongs_to :base_version, :class_name => 'PackageVersion'
  has_many :successors, :class_name => 'PackageVersion', :foreign_key => 'base_version_id'
end
