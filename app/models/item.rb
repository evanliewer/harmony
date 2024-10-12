class Item < ApplicationRecord
  # 🚅 add concerns above.

  attr_accessor :layout_removal
  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :location, optional: true
  # 🚅 add belongs_to associations above.

  has_many :applied_tags, class_name: "Items::AppliedTag", dependent: :destroy
  has_many :tags, through: :applied_tags, class_name: "Items::Tag"
  has_many :options, class_name: "Items::Option", dependent: :destroy
  # 🚅 add has_many associations above.

  has_one_attached :layout
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :location, scope: true
  # 🚅 add validations above.

  after_validation :remove_layout, if: :layout_removal?
  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_locations
    team.locations
  end

  def valid_tags
   team.items_tags.order(:name)
  end

  def layout_removal?
    layout_removal.present?
  end

  def remove_layout
    layout.purge
  end

  # 🚅 add methods above.
end
