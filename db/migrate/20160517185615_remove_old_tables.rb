  class RemoveOldTables < ActiveRecord::Migration
  def change
    remove_column :tasks, :system_update_id
    drop_table :package_installations
    drop_table :system_updates
    drop_table :package_updates
    drop_table :system_update_states
  end
end
