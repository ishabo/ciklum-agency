class AddKeyNameToBonusScheme < ActiveRecord::Migration
  def change
  	  	add_column :bonus_schemes, :key_name, :string, :required => true
  end
end
