class Retreats::Request < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :retreat
  belongs_to :department, optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :retreat, scope: true
  validates :department, scope: true
  validates :department_id, uniqueness: { scope: :retreat_id, message: "already has a request for this retreat. Please edit their existing one" }
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_retreats
    team.retreats
  end

  def valid_departments
    team.departments
  end

  # 🚅 add methods above.
end
