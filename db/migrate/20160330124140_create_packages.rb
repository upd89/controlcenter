class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.string :section
      t.string :homepage
      t.string :summary

      t.timestamps null: false
    end
  end
end
