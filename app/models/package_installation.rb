class PackageInstallation < ActiveRecord::Base
  belongs_to :package
  belongs_to :system
end
