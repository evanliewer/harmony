class CreateNotificationsRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications_requests do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.references :user, null: true, foreign_key: {to_table: "memberships"}
      t.references :notifications_flag, null: true, foreign_key: {to_table: "notifications_flags"}
      t.string :days_before
      t.boolean :email, default: false

      t.timestamps
    end
  end
end
