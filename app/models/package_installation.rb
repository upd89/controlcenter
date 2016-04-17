# an installation of a specific package on a specific system
class PackageInstallation < ActiveRecord::Base
  belongs_to :package
  belongs_to :system
end
