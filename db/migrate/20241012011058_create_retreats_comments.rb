class CreateRetreatsComments < ActiveRecord::Migration[7.1]
  def change
    create_table :retreats_comments do |t|
      t.references :retreat, null: false, foreign_key: true
      t.string :name
      t.references :user, null: true, foreign_key: {to_table: "memberships"}

      t.timestamps
    end
  end
end
