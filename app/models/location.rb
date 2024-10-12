class Location < ApplicationRecord
  include Sortable
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  has_many :retreats_location_tags, class_name: "Retreats::LocationTag", dependent: :destroy
  has_many :retreats, through: :retreats_location_tags
  has_many :questions_location_tags, class_name: "Questions::LocationTag", dependent: :destroy
  has_many :questions, through: :questions_location_tags
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def collection
    team.locations
  end

  # 🚅 add methods above.
end
