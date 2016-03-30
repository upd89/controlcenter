class CreateTaskExecutions < ActiveRecord::Migration
  def change
    create_table :task_executions do |t|
      t.string :log

      t.timestamps null: false
    end
  end
end
