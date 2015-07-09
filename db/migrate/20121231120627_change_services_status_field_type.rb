class ChangeServicesStatusFieldType < ActiveRecord::Migration
  def up
  	change_column :services, :success_status, :integer, :default => 1, :null => false
  #connection.execute(%q{
	#    alter table services
	#    alter column success_status
	#    type integer using cast(success_status as integer)
	#})
    
  end

  def down
  end
end
