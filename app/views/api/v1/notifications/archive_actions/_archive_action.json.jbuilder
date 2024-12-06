json.extract! archive_action,
  :id,
  :team_id,
  :target_all,
  :target_ids,
  :target_count,
  :performed_count,
  :created_by_id,
  :approved_by_id,
  :scheduled_for,
  :started_at,
  :completed_at,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_notifications_archive_action_url(archive_action, format: :json)
