class AddIsBossToUser < ActiveRecord::Migration
  def change
  	add_column :users, :is_manager, :boolean, :default => false
  end
end
