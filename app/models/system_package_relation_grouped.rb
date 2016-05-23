# This is a report from a SQL View
class SystemPackageRelationGrouped < ActiveRecord::Base
  self.table_name = 'system_package_relation_grouped'

  def to_s
    "#{pkg_name}"
  end

  filterrific(
    default_filter_params: { sorted_by: 'name_asc' },
    available_filters: [
      :sorted_by,
      :sys_search_query,
      :pkg_search_query,
      :with_system_group_id,
      :with_package_group_id
    ]
  )

  scope :sys_search_query, lambda { |query|
    return nil  if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 2
    where(
      terms.map {
        or_clauses = [
          "LOWER(pkg_name) LIKE ?",
          "LOWER(pkg_section) LIKE ?"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }
  scope :pkg_search_query, lambda { |query|
    return nil  if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 2
    where(
      terms.map {
        or_clauses = [
          "LOWER(pkg_name) LIKE ?",
          "LOWER(pkg_section) LIKE ?"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }
  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^id_/
        order("pkg_id #{ direction }")
      when /^name_/
        order("pkg_name #{ direction }")
      when /^section_/
        order("LOWER(pkg_section) #{ direction }")
      when /^nr_of_systems_/
        order("sys_count #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  scope :with_system_group_id, lambda { |system_group_ids|
    where(:system_group_id => [*system_group_ids])
  }
  scope :with_package_group_id, lambda { |package_group_ids|
    where(:package_group_id => [*package_group_ids])
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
