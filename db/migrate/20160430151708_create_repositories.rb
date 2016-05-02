class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :origin
      t.string :archive
      t.string :component

      t.timestamps null: false
    end
  end
end
