class AddBaseVersionToPackageVersion < ActiveRecord::Migration
  def change
    add_column :package_versions, :base_version_id, :integer
  end
end
