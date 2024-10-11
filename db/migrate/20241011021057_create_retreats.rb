class CreateRetreats < ActiveRecord::Migration[7.1]
  def change
    create_table :retreats do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.datetime :arrival
      t.datetime :departure
      t.integer :guest_count
      t.references :organization, null: true, foreign_key: true
      t.boolean :internal, default: false
      t.boolean :active, default: false
      t.string :jotform

      t.timestamps
    end
  end
end
