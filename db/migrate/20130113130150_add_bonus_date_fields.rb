class AddBonusDateFields < ActiveRecord::Migration
  def up
  	add_column :bonuses, :due_month, :integer
  	add_column :bonuses, :payment_date, :date
  end

  def down
  end
end
