class AddCreatedByToServices < ActiveRecord::Migration
  def change
  	add_column :services, :created_by, :integer
  end
end
