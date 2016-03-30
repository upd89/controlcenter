class CreateSystemGroups < ActiveRecord::Migration
  def change
    create_table :system_groups do |t|
      t.string :name
      t.integer :permission_level

      t.timestamps null: false
    end
  end
end
