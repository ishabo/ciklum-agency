class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :type
      t.string :project_id
      t.text :description
      t.boolean :spec_sent
      t.boolean :proposal_sent
      t.datetime :start_date
      t.integer :duration
      t.datetime :created_at

      t.timestamps
    end
  end
end
