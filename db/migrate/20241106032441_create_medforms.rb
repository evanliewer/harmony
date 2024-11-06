class CreateMedforms < ActiveRecord::Migration[7.2]
  def change
    create_table :medforms do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.references :retreat, null: true, foreign_key: true
      t.string :phone
      t.string :email
      t.string :dietary

      t.timestamps
    end
  end
end
