# allows easy customization of permissions for users by assigning them roles
class Role < ActiveRecord::Base
  validates_presence_of :name, :permission_level
  validates_uniqueness_of :name
  validates_numericality_of :permission_level

  has_many :users, :dependent => :restrict_with_error

  before_destroy :check_for_users

  private

  def check_for_users
    if users.count > 0
      errors.add :base, "cannot delete role while users with this role exist"
      return false
    end
  end
end
