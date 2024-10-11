class Flights::Check < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :retreat, optional: true
  belongs_to :flight, optional: true
  belongs_to :user, class_name: "Membership", optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :retreat, scope: true
  validates :flight, scope: true
  validates :user, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_retreats
    team.retreats
  end

  def valid_flights
    team.flights
  end

  def valid_users
    team.memberships.current_and_invited
  end

  # 🚅 add methods above.
end
