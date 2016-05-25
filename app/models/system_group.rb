# a manually created/assembled collection of systems
class SystemGroup < ActiveRecord::Base
  has_many :systems, :dependent => :restrict_with_error
  validates_presence_of :name

  def self.options_for_select
    order('LOWER(name)').map { |e| [e.name, e.id] }
  end

  def has_installable_CPVs
    systems.reject{ |s| s.get_installable_CPVs.count < 1 }.count > 0
  end

  def get_nr_of_installable_CPVs
    systems.map{ |s| s.get_installable_CPVs.count }.inject(:+)
  end
end
