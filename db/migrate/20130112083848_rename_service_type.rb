class RenameServiceType < ActiveRecord::Migration
  def up
  	rename_column :services, :service_type, :service_type_id
    change_column :services, :service_type_id, :integer
  	#connection.execute(%q{
	  #  alter table services
	  #  alter column service_type_id
	  #  type integer using cast(service_type_id as integer)
	  #})
  end

  def down
  end
end
