class CreateSystemUpdateStates < ActiveRecord::Migration
  def change
    create_table :system_update_states do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
