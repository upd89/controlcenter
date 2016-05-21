class AddPreviewStateToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :is_in_preview, :boolean
  end
end
