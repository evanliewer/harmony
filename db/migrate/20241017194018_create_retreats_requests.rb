class CreateRetreatsRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :retreats_requests do |t|
      t.references :team, null: false, foreign_key: true
      t.references :retreat, null: false, foreign_key: true
      t.references :department, null: true, foreign_key: true
      t.string :notes

      t.timestamps
    end
  end
end
