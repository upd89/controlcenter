class CreatePackageInstallations < ActiveRecord::Migration
  def change
    create_table :package_installations do |t|
      t.string :installed_version
      t.references :package, index: true, foreign_key: true
      t.references :system, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
