class RenameColumnsInBonusesToRemoveBonusSuffix < ActiveRecord::Migration
  def up
  	rename_column :bonuses, :bonus_value, :value
  end

  def down
  end
end
