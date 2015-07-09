class AddStatusToBonus < ActiveRecord::Migration
  def change
  	add_column :bonuses, :eligibility, :integer, :required => true
  end
end
