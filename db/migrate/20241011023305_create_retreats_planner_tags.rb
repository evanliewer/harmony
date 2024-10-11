class CreateRetreatsPlannerTags < ActiveRecord::Migration[7.1]
  def change
    create_table :retreats_planner_tags do |t|
      t.references :retreat, null: false, foreign_key: true
      t.references :planner, null: false, foreign_key: {to_table: "memberships"}

      t.timestamps
    end
  end
end
