class CreateRetreatsAssignedContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :retreats_assigned_contacts do |t|
      t.references :retreat, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: {to_table: "organizations_contacts"}

      t.timestamps
    end
  end
end
