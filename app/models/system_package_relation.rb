# This is a report from a SQL View
class SystemPackageRelation < ActiveRecord::Base
  self.table_name = 'system_package_relation'

  def to_s
    "#{pkg_name}, #{version}"
  end

  protected

  # The report_state_popularities relation is a SQL view,
  # so there is no need to try to edit its records ever.
  # Doing otherwise, will result in an exception being thrown
  # by the database connection.
  def readonly?
    true
  end
end # class
