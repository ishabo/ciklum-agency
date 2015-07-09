class AddServiceSoldByDefaultValue < ActiveRecord::Migration
  def up
  	change_column :services, :sold_by, :integer, :default => 0, :null => false
  end

  def down
  end
end
