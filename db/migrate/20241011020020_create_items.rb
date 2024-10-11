class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.references :location, null: true, foreign_key: true
      t.boolean :active, default: false
      t.integer :overlap_offset
      t.string :image_tag
      t.boolean :clean, default: false
      t.integer :flip_time
      t.integer :beds

      t.timestamps
    end
  end
end
