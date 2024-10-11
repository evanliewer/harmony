class CreateRetreatsLocationTags < ActiveRecord::Migration[7.1]
  def change
    create_table :retreats_location_tags do |t|
      t.references :retreat, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
