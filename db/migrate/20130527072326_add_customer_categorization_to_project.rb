class AddCustomerCategorizationToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :abc, :integer, :required => true  	
  end
end
