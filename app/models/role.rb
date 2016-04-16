class Role < ActiveRecord::Base
  validates_presence_of :name, :permission_level
  validates_uniqueness_of :name
  validates_numericality_of :permission_level

  has_many :users
end
