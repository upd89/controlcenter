# a manually created/assembled collection of systems
class SystemGroup < ActiveRecord::Base
  has_many :systems, :dependent => :restrict_with_error
  validates_presence_of :name
end
