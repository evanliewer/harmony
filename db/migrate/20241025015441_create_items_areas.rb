class CreateItemsAreas < ActiveRecord::Migration[7.2]
  def change
    create_table :items_areas do |t|
      t.references :team, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.references :location, null: true, foreign_key: true

      t.timestamps
    end
  end
end
