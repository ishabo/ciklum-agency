class AddBudgetToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :budget, :integer, :default => 0
  end
end
