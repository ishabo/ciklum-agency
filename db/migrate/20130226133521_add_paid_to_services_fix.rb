class AddPaidToServicesFix < ActiveRecord::Migration
  def change
  	  	remove_column :bonuses, :is_paid
	  	add_column :services, :is_paid, :boolean, :default => false, :null => false
  end
end
