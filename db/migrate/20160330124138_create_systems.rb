class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems do |t|
      t.string :name
      t.string :urn
      t.string :os
      t.boolean :reboot_required
      t.string :address
      t.datetime :last_seen
      t.references :system_group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
