class User < ActiveRecord::Base
  validates_presence_of :name, :role, :email
  validates_uniqueness_of :name

  belongs_to :role
end
