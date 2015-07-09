class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :name
      t.boolean :has_bonus

      t.timestamps
    end
  end
end
