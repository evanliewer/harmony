class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.references :retreat, null: true, foreign_key: true
      t.references :item, null: true, foreign_key: true
      t.references :user, null: true, foreign_key: {to_table: "memberships"}
      t.datetime :start_time
      t.datetime :end_time
      t.integer :quantity
      t.string :notes
      t.boolean :seasonal_default, default: false
      t.boolean :exclusive, default: false
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
