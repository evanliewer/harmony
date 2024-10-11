class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
   unless table_exists?(:organizations) 
    create_table :organizations do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :website

      t.timestamps
     end 
    end
  end
end
