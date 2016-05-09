class AddTriesToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :tries, :integer, default: 0
  end
end
