class CreateConcretePackageVersions < ActiveRecord::Migration
  def change
    create_table :concrete_package_versions do |t|
      t.references :system, index: true, foreign_key: true
      t.references :task, index: true, foreign_key: true
      t.references :concrete_package_state, index: true, foreign_key: true
      t.references :package_version, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
