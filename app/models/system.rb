# a single server node where an agent is installed
class System < ActiveRecord::Base
  belongs_to :system_group

  has_many :concrete_package_versions
  has_many :package_versions, -> { distinct }, through: :concrete_package_versions
  has_many :packages, -> { distinct }, through: :package_versions

  has_many :tasks, -> { distinct }, through: :concrete_package_versions

  validates_presence_of :urn

  filterrific(
    default_filter_params: { sorted_by: 'registered_at_desc' },
    available_filters: [
      :sorted_by,
      :sys_search_query,
      :with_system_group_id
    ]
  )

    def self.get_maybe_create(system)
        if exists?(:urn => system["urn"])
            system_obj = where(urn: system["urn"])[0]
        else
            system_obj = new
            apply_system_properties( system_obj, system )
            system_obj.system_group = SystemGroup.first
            system_obj.last_seen = DateTime.now
            system_obj.save()
        end
        return system_obj
    end


  # Scope definitions. We implement all Filterrific filters through ActiveRecord
  # scopes. In this example we omit the implementation of the scopes for brevity.
  # Please see 'Scope patterns' for scope implementation details.
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
    num_or_conditions = 3
    where(
      terms.map {
        or_clauses = [
          "LOWER(systems.name) LIKE ?",
          "LOWER(systems.urn) LIKE ?",
          "LOWER(systems.address) LIKE ?"
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
      when /^registered_at_/
        order("systems.created_at #{ direction }")
      when /^name_/
        order("LOWER(systems.name) #{ direction }")
      when /^urn_/
        order("LOWER(systems.urn) #{ direction }")
      when /^os_/
        order("LOWER(systems.os) #{ direction }")
      when /^reboot_required_/
        order("systems.reboot_required #{ direction }")
      when /^address_/
        order("LOWER(systems.address) #{ direction }")
      when /^last_seen_/
        order("systems.last_seen #{ direction }")
      when /^system_group_/ #TODO: doesn't work yet!
        order("system_groups.name #{ direction }").includes(:system_group)
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  scope :with_system_group_id, lambda { |system_group_ids|
    where(:system_group_id => [*system_group_ids])
  }

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Registration date (newest first)', 'registered_at_desc'],
      ['Registration date (oldest first)', 'registered_at_asc']
    ]
  end

  self.per_page = Settings.Pagination.NoOfEntriesPerPage

  def get_installable_CPVs
    cpv_state_avail = ConcretePackageState.where(name: "Available")[0]
    ConcretePackageVersion.where(system: self, concrete_package_state: cpv_state_avail )
  end

  def decorated_created_at
      created_at.to_formatted_s(:short)
  end

  def self.options_for_select
    order('LOWER(name)').map { |e| [e.name, e.id] }
  end

  def decorated_last_seen
    if ( last_seen )
      last_seen.to_formatted_s(:short)
    else
      "not yet"
    end
  end
end
