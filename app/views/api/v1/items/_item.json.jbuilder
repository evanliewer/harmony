json.extract! item,
  :id,
  :team_id,
  :name,
  :description,
  :location_id,
  :active,
  :overlap_offset,
  :image_tag,
  :clean,
  :flip_time,
  :beds,
  :tag_ids,
  :items_area_id,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at

json.layout url_for(item.layout) if item.layout.attached?
# 🚅 super scaffolding will insert file-related logic above this line.
