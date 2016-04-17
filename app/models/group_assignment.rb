# resolves many-to-many links between Packages and PackageGroups
class GroupAssignment < ActiveRecord::Base
  belongs_to :package_group
  belongs_to :package
end
