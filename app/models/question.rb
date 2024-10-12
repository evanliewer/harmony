class Question < ApplicationRecord
  include Sortable
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  has_many :location_tags, class_name: "Questions::LocationTag", dependent: :destroy
  has_many :locations, through: :location_tags
  has_many :demographic_tags, class_name: "Questions::DemographicTag", dependent: :destroy
  has_many :demographics, through: :demographic_tags
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def collection
    team.questions
  end

  def valid_locations
    team.locations
  end

  def valid_demographics
    team.demographics
  end

  # 🚅 add methods above.
end
