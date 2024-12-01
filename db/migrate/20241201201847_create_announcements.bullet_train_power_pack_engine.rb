# This migration comes from bullet_train_power_pack_engine (originally 20240229114551)
class CreateAnnouncements < ActiveRecord::Migration[7.1]
  def change
    create_table :announcements do |t|
      t.string :title
      t.datetime :published_at
      t.datetime :delivered_at
      t.string :kind, index: true
      t.jsonb :delivery_methods, default: [], index: { using: :gin }
      t.jsonb :role_ids, default: [], index: { using: :gin }
      t.jsonb :price_ids, default: [], index: { using: :gin }

      t.timestamps
    end
  end
end
