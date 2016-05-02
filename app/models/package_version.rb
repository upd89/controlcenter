class PackageVersion < ActiveRecord::Base
  belongs_to :package
  belongs_to :distribution
  belongs_to :repository
end
