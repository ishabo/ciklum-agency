class AddPositionKeyName < ActiveRecord::Migration
  def change
  	add_column :positions, :abbr, :string
  end
end