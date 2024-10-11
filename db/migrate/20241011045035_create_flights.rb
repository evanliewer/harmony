class CreateFlights < ActiveRecord::Migration[7.1]
  def change
    create_table :flights do |t|
      t.references :team, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.string :description
      t.boolean :external, default: false
      t.boolean :preflight, default: false
      t.integer :warning

      t.timestamps
    end
  end
end
