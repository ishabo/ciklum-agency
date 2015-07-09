class AddEmployedToUser < ActiveRecord::Migration
  def change
  	  	add_column :users, :is_employed, :boolean, :default => true
  end
end
