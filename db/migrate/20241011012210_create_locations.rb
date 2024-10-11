class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.references :team, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.string :initials
      t.integer :capacity
      t.string :hex_color
      t.string :active

      t.timestamps
    end
  end
end
