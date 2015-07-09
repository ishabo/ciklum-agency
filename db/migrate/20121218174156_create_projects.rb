class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :client
      t.string :project_manager
      t.integer :hub_id
      t.string :sales_manager
      t.text :description

      t.timestamps
    end
  end
end
