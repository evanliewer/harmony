class CreateQuestionsDemographicTags < ActiveRecord::Migration[7.1]
  def change
    create_table :questions_demographic_tags do |t|
      t.references :question, null: false, foreign_key: true
      t.references :demographic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
