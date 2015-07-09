class ChangeBonusReasonName < ActiveRecord::Migration
  def up
  	rename_column :bonuses, :bonus_reason, :bonus_scheme_id
  end

  def down
  end
end
