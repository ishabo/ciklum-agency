class AddHasBonusFieldToUsers < ActiveRecord::Migration
  def change
  	  	add_column :users, :has_bonus, :boolean, :default => false
  end
end
