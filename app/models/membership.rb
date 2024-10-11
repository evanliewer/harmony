class Membership < ApplicationRecord
  include Memberships::Base
  # 🚅 add concerns above.

  # 🚅 add belongs_to associations above.

  has_many :retreats_planner_tags, class_name: "Retreats::PlannerTag", dependent: :destroy
  has_many :retreats, through: :retreats_planner_tags
  has_many :retreats_host_tags, class_name: "Retreats::HostTag", dependent: :destroy
  has_many :retreats, through: :retreats_host_tags
  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
