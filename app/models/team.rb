class Team < ApplicationRecord
  include Teams::Base
  include Webhooks::Outgoing::TeamSupport
  # 🚅 add concerns above.

  # 🚅 add belongs_to associations above.

  has_many :demographics, dependent: :destroy, enable_cable_ready_updates: true
  has_many :departments, dependent: :destroy, enable_cable_ready_updates: true
  has_many :locations, dependent: :destroy, enable_cable_ready_updates: true
  has_many :items, dependent: :destroy, enable_cable_ready_updates: true
  has_many :organizations, dependent: :destroy, enable_cable_ready_updates: true
  has_many :retreats, dependent: :destroy, enable_cable_ready_updates: true
  has_many :reservations, dependent: :destroy, enable_cable_ready_updates: true
  has_many :items_tags, class_name: "Items::Tag", dependent: :destroy, enable_cable_ready_updates: true
  has_many :flights, dependent: :destroy, enable_cable_ready_updates: true
  has_many :flights_timeframes, class_name: "Flights::Timeframe", dependent: :destroy, enable_cable_ready_updates: true
  has_many :flights_checks, class_name: "Flights::Check", dependent: :destroy, enable_cable_ready_updates: true
  has_many :organizations_contacts, class_name: "Organizations::Contact", dependent: :destroy, enable_cable_ready_updates: true
  has_many :notifications, dependent: :destroy, enable_cable_ready_updates: true
  has_many :notifications_flags, class_name: "Notifications::Flag", dependent: :destroy, enable_cable_ready_updates: true
  has_many :notifications_requests, class_name: "Notifications::Request", dependent: :destroy, enable_cable_ready_updates: true
  has_many :seasons, dependent: :destroy, enable_cable_ready_updates: true
  has_many :questions, dependent: :destroy, enable_cable_ready_updates: true
  has_many :websiteimages, dependent: :destroy, enable_cable_ready_updates: true
  has_many :retreats_requests, class_name: "Retreats::Request", dependent: :destroy, enable_cable_ready_updates: true
  has_many :items_areas, class_name: "Items::Area", dependent: :destroy, enable_cable_ready_updates: true
  has_many :games, dependent: :destroy, enable_cable_ready_updates: true
  has_many :medforms, dependent: :destroy, enable_cable_ready_updates: true
  has_many :diets, dependent: :destroy
  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
