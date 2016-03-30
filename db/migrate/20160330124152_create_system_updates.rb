class CreateSystemUpdates < ActiveRecord::Migration
  def change
    create_table :system_updates do |t|
      t.references :system_update_state, index: true, foreign_key: true
      t.references :package_update, index: true, foreign_key: true
      t.references :system, index: true, foreign_key: true
      t.references :task, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
