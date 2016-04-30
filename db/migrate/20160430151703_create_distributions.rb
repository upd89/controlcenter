class CreateDistributions < ActiveRecord::Migration
  def change
    create_table :distributions do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
