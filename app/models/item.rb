class Item < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :location, optional: true
  # 🚅 add belongs_to associations above.

  has_many :applied_tags, class_name: "Items::AppliedTag", dependent: :destroy
  has_many :tags, through: :applied_tags, class_name: "Items::Tag"
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :location, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_locations
    team.locations
  end

  def valid_tags
    team.items_tags.order(:name)
  end

  # 🚅 add methods above.
end
