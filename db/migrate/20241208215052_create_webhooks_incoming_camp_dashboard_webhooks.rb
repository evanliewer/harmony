class CreateWebhooksIncomingCampDashboardWebhooks < ActiveRecord::Migration[7.2]
  def change
    create_table :webhooks_incoming_camp_dashboard_webhooks do |t|
      t.jsonb :data
      t.datetime :processed_at
      t.datetime :verified_at

      t.timestamps
    end
  end
end
