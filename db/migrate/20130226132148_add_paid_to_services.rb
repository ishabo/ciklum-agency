class AddPaidToServices < ActiveRecord::Migration
  def change
  	add_column :bonuses, :is_paid, :boolean, :default => false, :null => false
  end
end
