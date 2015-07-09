class AddConvertedToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :converted, :boolean, :default => false
  	add_column :projects, :engagement_type, :boolean, :default => 1
  end
end
