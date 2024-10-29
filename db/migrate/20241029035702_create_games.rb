class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.references :team, null: false, foreign_key: true
      t.string :red_score
      t.string :blue_score
      t.string :yellow_score
      t.string :green_score

      t.timestamps
    end
  end
end
