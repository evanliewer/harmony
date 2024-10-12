class CreateNotificationsFlags < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications_flags do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.references :department, null: true, foreign_key: true

      t.timestamps
    end
  end
end
