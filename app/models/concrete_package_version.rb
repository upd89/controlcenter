class ConcretePackageVersion < ActiveRecord::Base
  belongs_to :system
  belongs_to :task
  belongs_to :concrete_package_state
  belongs_to :package_version

  filterrific(
    default_filter_params: { sorted_by: 'id_desc' },
    available_filters: [
      :sorted_by,
      :with_state_id
    ]
  )

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^id_/
        order("concrete_package_versions.id #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  scope :with_state_id, lambda { |state_ids|
    where(concrete_package_state_id: [*state_ids])
  }
end
