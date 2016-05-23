# resolves many-to-many links between Packages and PackageGroups
class GroupAssignment < ActiveRecord::Base
  belongs_to :package_group
  belongs_to :package

  filterrific(
    default_filter_params: { sorted_by: 'id_desc' },
    available_filters: [
      :sorted_by,
      :pkg_search_query
    ]
  )

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^id_/
        order("id #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
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
    pkgs = Package.where(
      terms.map {
        or_clauses = [
          "LOWER(name) LIKE ?",
          "LOWER(section) LIKE ?"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )

    pkg_ids = []
    pkgs.each do | pkg |
      pkg_ids.append(pkg.id)
    end
    where(:package_id => pkg_ids)
  }

  self.per_page = Settings.Pagination.NoOfEntriesPerPage
end
