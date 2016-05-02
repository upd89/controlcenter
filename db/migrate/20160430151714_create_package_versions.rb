class CreatePackageVersions < ActiveRecord::Migration
  def change
    create_table :package_versions do |t|
      t.string :sha256
      t.string :version
      t.string :architecture
      t.references :package, index: true, foreign_key: true
      t.references :distribution, index: true, foreign_key: true
      t.references :repository, index: true, foreign_key: true
      t.boolean :is_base_version

      t.timestamps null: false
    end
  end
end
