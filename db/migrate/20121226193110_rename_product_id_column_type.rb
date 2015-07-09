class RenameProductIdColumnType < ActiveRecord::Migration
  def up
  	  change_column :services, :project_id, :integer
  	  #connection.execute(%q{
	  #  alter table services
	  #  alter column project_id
	  #  type integer using cast(project_id as integer)
	  #})
  end

  def down
  end
end
