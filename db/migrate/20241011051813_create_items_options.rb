class CreateItemsOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :items_options do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.integer :capacity
      t.string :image_tag

      t.timestamps
    end
  end
end
