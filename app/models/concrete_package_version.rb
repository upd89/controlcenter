class ConcretePackageVersion < ActiveRecord::Base
  belongs_to :system
  belongs_to :task
  belongs_to :concrete_package_state
  belongs_to :package_version
end
