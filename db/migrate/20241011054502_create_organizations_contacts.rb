class CreateOrganizationsContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations_contacts do |t|
      t.references :team, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :job_title
      t.string :primary_phone
      t.string :email

      t.timestamps
    end
  end
end
