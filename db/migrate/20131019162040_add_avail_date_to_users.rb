class AddAvailDateToUsers < ActiveRecord::Migration
  def change
  	  add_column :users, :avail_date, :string, :required => false
  end
end
