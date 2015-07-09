class AddBundgetColumnToServices < ActiveRecord::Migration
  def change
  	add_column :services, :budget, :integer, :default => 0
  end
end
