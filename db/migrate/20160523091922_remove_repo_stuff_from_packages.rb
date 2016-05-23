class RemoveRepoStuffFromPackages < ActiveRecord::Migration
  def change
    remove_column :packages, :base_version if column_exists? :packages, :base_version
    remove_column :packages, :architecture if column_exists? :packages, :architecture
    remove_column :packages, :repository   if column_exists? :packages, :repository
  end
end
