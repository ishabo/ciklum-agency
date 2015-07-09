class CreateBonuses < ActiveRecord::Migration
  def change
    create_table :bonuses do |t|
      t.integer :user_id
      t.integer :project_id
      t.float :bonus_value
      t.integer :bonus_reason
      t.boolean :claimed
      t.boolean :paid

      t.timestamps
    end
  end
end
