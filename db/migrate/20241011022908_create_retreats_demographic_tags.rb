class CreateRetreatsDemographicTags < ActiveRecord::Migration[7.1]
  def change
    create_table :retreats_demographic_tags do |t|
      t.references :retreat, null: false, foreign_key: true
      t.references :demographic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
