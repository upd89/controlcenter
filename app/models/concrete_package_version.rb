class ConcretePackageVersion < ActiveRecord::Base
  belongs_to :system
  belongs_to :task
  belongs_to :concrete_package_state
  belongs_to :package_version

  filterrific(
    default_filter_params: { sorted_by: 'id_asc' },
    available_filters: [
      :sorted_by,
      :with_state_id
    ]
  )

  # used in API
  def self.create_new(pkgVersion, sys, state)
      cpv_state_avail = ConcretePackageState.find_by(name: "Available")
      cpv_state_outdated = ConcretePackageState.find_by(name: "Outdated")

      state = cpv_state_avail unless defined? state

      # only one connection from package version to system allowed
      if exists?(package_version: pkgVersion, system: sys)
        assoc = where(package_version: pkgVersion, system: sys)[0]
        assoc.concrete_package_state = state
        assoc.save
      else
        # Set other CPVs to Outdated!
        sys.package_versions.where( package: pkgVersion.package ).each do |other_package_version|
          cpv = ConcretePackageVersion.where( system: sys, package_version: other_package_version )[0]
          cpv.concrete_package_state = cpv_state_outdated
          cpv.save
        end

        assoc = ConcretePackageVersion.create(
          system: sys,
          package_version: pkgVersion,
          concrete_package_state: state
        )
      end
      return assoc
  end


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

  def self.options_for_sorted_by
    [
      ['ID (1-n)', 'id_asc']
    ]
  end
end
