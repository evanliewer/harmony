class Medform < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :retreat, optional: true
  belongs_to :diet, optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :address, class_name: "Address", as: :addressable
  accepts_nested_attributes_for :address
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :retreat, scope: true
  validates :diet, scope: true
  validates :terms, presence: true
  validates :phone, presence: true
  validates :email, presence: true
  validates :age, presence: true
  validates :gender, presence: true
  validates :emergency_contact_name, presence: true
  validates :emergency_contact_phone, presence: true
  validates :emergency_contact_relationship, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_retreats
    #team.retreats
    Retreat.all
  end

  def valid_diets
    #Not used as team is not passed to model
    team.diets
  end


  # 🚅 add methods above.
end
