class CreateFlightsChecks < ActiveRecord::Migration[7.1]
  def change
    create_table :flights_checks do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.references :retreat, null: true, foreign_key: true
      t.references :flight, null: true, foreign_key: true
      t.references :user, null: true, foreign_key: {to_table: "memberships"}
      t.datetime :completed_at

      t.timestamps
    end
  end
end
