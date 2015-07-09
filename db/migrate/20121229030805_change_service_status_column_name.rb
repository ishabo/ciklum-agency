class ChangeServiceStatusColumnName < ActiveRecord::Migration
  def up
  	rename_column :services, :status, :success_status
  end

  def down
  end
end
