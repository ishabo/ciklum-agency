class AddCommentsToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :status_comment, :text
  end
end
