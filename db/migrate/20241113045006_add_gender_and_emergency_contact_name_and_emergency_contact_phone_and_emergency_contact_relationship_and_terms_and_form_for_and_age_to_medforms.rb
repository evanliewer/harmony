class AddGenderAndEmergencyContactNameAndEmergencyContactPhoneAndEmergencyContactRelationshipAndTermsAndFormForAndAgeToMedforms < ActiveRecord::Migration[7.2]
  def change
    add_column :medforms, :gender, :string
    add_column :medforms, :emergency_contact_name, :string
    add_column :medforms, :emergency_contact_phone, :string
    add_column :medforms, :emergency_contact_relationship, :string
    add_column :medforms, :terms, :boolean, default: false
    add_column :medforms, :form_for, :string
    add_column :medforms, :age, :string
  end
end
