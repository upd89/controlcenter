# a manually created/assembled collection of systems
class SystemGroup < ActiveRecord::Base
  has_many :systems

  validates_presence_of :name
end
