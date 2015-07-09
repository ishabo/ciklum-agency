class ChangeClaimedDefault < ActiveRecord::Migration
  def up
  	change_column :bonuses, :claimed, :boolean, :default => 0, :null => false
  end

  def down
  end
end
