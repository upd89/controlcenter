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
        if exists?( sha256: pkgVersion['sha256'] )
            pkgVersion_obj = where( sha256: pkgVersion['sha256'] )[0]
        else
            pkgVersion_obj = create( {
              :sha256       => pkgVersion['sha256'],
              :version      => pkgVersion['version'],
              :architecture => pkgVersion['architecture'],
              :package      => pkg
            } )
        end
        return pkgVersion_obj
    end

end
