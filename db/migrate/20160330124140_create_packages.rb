class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.string :base_version
      t.string :architecture
      t.string :section
      t.string :repository
      t.string :homepage
      t.string :summary

      t.timestamps null: false
    end
  end
end
