# a single package, containing an application
class Package < ActiveRecord::Base
  validates_presence_of :name
end
