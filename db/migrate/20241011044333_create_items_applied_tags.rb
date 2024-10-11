class CreateItemsAppliedTags < ActiveRecord::Migration[7.1]
  def change
   unless table_exists?(:items_applied_tags)  
    create_table :items_applied_tags do |t|
      t.references :item, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: {to_table: "items_tags"}

      t.timestamps
    end
  end
 end
end
