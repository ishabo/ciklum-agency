class MakeConvertedNull < ActiveRecord::Migration
  def up
  	change_column :projects, :converted, :integer, :default => 0
  end

  def down
  end
end
