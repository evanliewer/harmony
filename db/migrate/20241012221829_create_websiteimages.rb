class CreateWebsiteimages < ActiveRecord::Migration[7.1]
  def change
    create_table :websiteimages do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.string :image

      t.timestamps
    end
  end
end
