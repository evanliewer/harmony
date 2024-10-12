class Retreats::AssignedContact < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :retreat
  belongs_to :contact, class_name: "Organizations::Contact"
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :contact, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_contacts
    retreat.valid_organizations_contacts
  end

  # 🚅 add methods above.
end
