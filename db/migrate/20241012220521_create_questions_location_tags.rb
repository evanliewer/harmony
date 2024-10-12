class CreateQuestionsLocationTags < ActiveRecord::Migration[7.1]
  def change
    create_table :questions_location_tags do |t|
      t.references :question, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
