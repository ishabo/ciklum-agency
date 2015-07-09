class AddServiceSstatus < ActiveRecord::Migration
  def up
  	add_column :services, :status, :string, :required => true
  end

  def down
  end
end
