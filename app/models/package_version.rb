class PackageVersion < ActiveRecord::Base
  belongs_to :package
  belongs_to :distribution
  belongs_to :repository

  has_many :concrete_package_versions

  belongs_to :base_version, class_name: "PackageVersion"
  has_many :successors, class_name: "PackageVersion", foreign_key: "base_version_id"

  validates :sha256, presence: true, uniqueness: true

  # used in api
  def self.get_maybe_create(pkg_version, pkg)
    pkg_version_obj = nil
    begin
      self.transaction(isolation: :serializable) do
        pkg_version_obj = create_with(
          version: pkg_version["version"],
          architecture: pkg_version["architecture"],
          package: pkg
        ).find_or_create_by(sha256: pkg_version["sha256"])
      end
    rescue ActiveRecord::StatementInvalid
      logger.debug("ActiveRecord: StatementInvalid Exception")
      logger.debug("failed package version for pkg: " + pkg.name)
      sleep(rand(100) * 0.005)
      retry
    end
    pkg_version_obj
  end
end
