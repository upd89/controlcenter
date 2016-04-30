class CreateConcretePackageStates < ActiveRecord::Migration
  def change
    create_table :concrete_package_states do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
