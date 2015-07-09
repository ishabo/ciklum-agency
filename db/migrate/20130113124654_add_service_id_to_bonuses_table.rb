class AddServiceIdToBonusesTable < ActiveRecord::Migration
  def change
  	add_column :bonuses, :service_id, :integer, :required => true
  end
end
