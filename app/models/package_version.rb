class PackageVersion < ActiveRecord::Base
  belongs_to :package
  belongs_to :distribution
  belongs_to :repository

  has_many :concrete_package_versions

  belongs_to :base_version, :class_name => 'PackageVersion'
  has_many :successors, :class_name => 'PackageVersion', :foreign_key => 'base_version_id'

  validates_presence_of :sha256, uniqueness: true

    # used in api
    def self.get_maybe_create(pkgVersion, pkg)
        pkgVersion_obj = nil
        begin
            self.transaction(isolation: :serializable) do
                pkgVersion_obj = self.create_with(
                    version: pkgVersion['version'],
                    architecture: pkgVersion['architecture'],
                    pkg: pkg
                ).find_or_create_by(sha256: pkgVersion['sha256'])
            end
        rescue ActiveRecord::StatementInvalid
            logger.debug("ActiveRecord: StatementInvalid Exception")
            retry
        end
        return pkgVersion_obj
    end

end
