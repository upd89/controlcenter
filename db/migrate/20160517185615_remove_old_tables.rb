  class RemoveOldTables < ActiveRecord::Migration
  def change
    remove_column :tasks, :system_update_id if column_exists? :tasks, :system_update_id
    drop_table :package_installations if table_exists? :package_installations
    drop_table :system_updates if table_exists? :system_updates
    drop_table :package_updates if table_exists? :package_updates
    drop_table :system_update_states if table_exists? :system_update_states
  end
end
