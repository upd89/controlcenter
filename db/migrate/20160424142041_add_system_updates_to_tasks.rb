class AddSystemUpdatesToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :system_update, foreign_key: true
  end
end
