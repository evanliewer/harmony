class Retreats::DemographicTag < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :retreat
  belongs_to :demographic
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :demographic, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_demographics
    retreat.valid_demographics
  end

  # 🚅 add methods above.
end
