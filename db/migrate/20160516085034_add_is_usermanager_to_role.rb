class AddIsUsermanagerToRole < ActiveRecord::Migration
  def change
    add_column :roles, :is_user_manager, :boolean, default: false
  end
end
