class AddServiceSoldBy < ActiveRecord::Migration
  def up
  	    add_column :services, :sold_by, :integer
  end

  def down
  end
end
