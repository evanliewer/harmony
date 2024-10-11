class CreateItemsTags < ActiveRecord::Migration[7.1]
  def change
    create_table :items_tags do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.boolean :ticketable, default: false
      t.boolean :schedulable, default: false
      t.boolean :optionable, default: false
      t.boolean :exclusivable, default: false
      t.boolean :cleanable, default: false
      t.boolean :publicable, default: false

      t.timestamps
    end
  end
end
