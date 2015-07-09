class CreateBonusSchemes < ActiveRecord::Migration
  def change
    create_table :bonus_schemes do |t|
      t.string :reason
      t.float :value

      t.timestamps
    end
  end
end
