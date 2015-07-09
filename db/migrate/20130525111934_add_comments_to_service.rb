class AddCommentsToService < ActiveRecord::Migration
  def change
  	add_column :services, :status_comment, :text
  end
end
