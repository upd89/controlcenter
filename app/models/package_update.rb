# A single update for a specific package
class PackageUpdate < ActiveRecord::Base
  belongs_to :package
  has_many :system_updates
end
