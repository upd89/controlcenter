# This is a report from a SQL View
class SystemPackageRelation < ActiveRecord::Base
  self.table_name = 'system_package_relation'

  def to_s
    "#{pkg_name}, #{version}"
  end

  filterrific(
    default_filter_params: { sorted_by: 'name_asc' },
    available_filters: [
      :sorted_by,
      :with_system_group_id
    ]
  )

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^id_/
        order("system_package_relations.id #{ direction }")
      when /^name_/
        order("pkg_name #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc']
    ]
  end

  self.per_page = Settings.Pagination.NoOfEntriesPerPage

  protected

  # The report_state_popularities relation is a SQL view,
  # so there is no need to try to edit its records ever.
  # Doing otherwise, will result in an exception being thrown
  # by the database connection.
  def readonly?
    true
  end
end # class
