class AddNoteToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :note, :string
  end
end
