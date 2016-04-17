# a manually created/assembled collection of systems
class SystemGroup < ActiveRecord::Base
  has_many :systems
end
