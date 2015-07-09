class RenameDatabaseColumn < ActiveRecord::Migration
  def up
  	rename_column :services, :type, :service_type
  end

  def down
  	 rename_column :services, :service_type, :type
  end
end
