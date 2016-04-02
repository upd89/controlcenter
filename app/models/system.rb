class System < ActiveRecord::Base
  belongs_to :system_group

  validates_presence_of :urn
end
