class AddSlugTitleToService < ActiveRecord::Migration
  def change
  	change_column :service_types, :key_name, :string, :required => true
  end
end
