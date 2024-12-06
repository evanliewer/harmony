class CreateNotificationsArchiveActions < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications_archive_actions do |t|
      t.references :team, null: false, foreign_key: true
      t.boolean :target_all, default: false
      t.jsonb :target_ids, default: []
      t.jsonb :failed_ids, default: []
      t.integer :last_completed_id, default: 0
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :target_count
      t.integer :performed_count, default: 0
      t.datetime :scheduled_for
      t.string :sidekiq_jid
      t.references :created_by, null: false, foreign_key: {to_table: "memberships"}, index: {name: "index_notifications_archives_on_created_by_id"}
      t.references :approved_by, null: true, foreign_key: {to_table: "memberships"}, index: {name: "index_notifications_archives_on_approved_by_id"}

      t.timestamps
    end
  end
end
