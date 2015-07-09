class AddPositionIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :position_id, :integer
    remove_column :users, :position
  end
end
