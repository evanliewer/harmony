class CreateSeasons < ActiveRecord::Migration[7.1]
  def change
    create_table :seasons do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.references :item, null: true, foreign_key: true
      t.datetime :season_start
      t.datetime :season_end
      t.datetime :start_time
      t.datetime :end_time
      t.integer :quantity
      t.string :notes

      t.timestamps
    end
  end
end
