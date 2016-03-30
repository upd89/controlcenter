class CreateGroupAssignments < ActiveRecord::Migration
  def change
    create_table :group_assignments do |t|
      t.references :package_group, index: true, foreign_key: true
      t.references :package, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
