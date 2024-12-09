class RenameHostIdToTagIdInItemsAppliedTags < ActiveRecord::Migration[7.1]
  def change
    # Rename the column commented out to upload to heroku
   # rename_column :items_applied_tags, :host_id, :tag_id

    # Rename the index if needed
    #rename_index :items_applied_tags, :index_items_applied_tags_on_host_id, :index_items_applied_tags_on_tag_id
  end
end
