class PackageGroup < ActiveRecord::Base
  has_many :group_assignments
  has_many :packages, -> { distinct }, through: :group_assignments, :dependent => :restrict_with_error

  validates_presence_of :name

  def self.options_for_select
    order('LOWER(name)').map { |e| [e.name, e.id] }
  end
end
