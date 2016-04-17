# representation of the installation of a specific update on a specific system
class SystemUpdate < ActiveRecord::Base
  belongs_to :system_update_state
  belongs_to :package_update
  belongs_to :system
  belongs_to :task
end
