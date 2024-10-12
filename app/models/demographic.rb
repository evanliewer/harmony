class Demographic < ApplicationRecord
  include Sortable
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  has_many :retreats_demographic_tags, class_name: "Retreats::DemographicTag", dependent: :destroy
  has_many :retreats, through: :retreats_demographic_tags
  has_many :questions_demographic_tags, class_name: "Questions::DemographicTag", dependent: :destroy
  has_many :questions, through: :questions_demographic_tags
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def collection
    team.demographics
  end

  # 🚅 add methods above.
end
