class CreatePackageUpdates < ActiveRecord::Migration
  def change
    create_table :package_updates do |t|
      t.string :candidate_version
      t.string :repository
      t.references :package, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
