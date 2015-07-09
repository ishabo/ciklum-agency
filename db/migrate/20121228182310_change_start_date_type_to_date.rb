class ChangeStartDateTypeToDate < ActiveRecord::Migration
  def up
  	  	change_column :services, :start_date, :date
  end

  def down
  end
end
