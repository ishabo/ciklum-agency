class ChangeProjectEngagementTypeToInteger < ActiveRecord::Migration
  def up
  	  	change_column :projects, :engagement_type, :integer, :default => 1
  end

  def down
  end
end
