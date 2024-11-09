class Item < ApplicationRecord
  # 🚅 add concerns above.

  attr_accessor :layout_removal
  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :location, optional: true
  belongs_to :items_area, class_name: "Items::Area", optional: true
  # 🚅 add belongs_to associations above.

  has_many :applied_tags, class_name: "Items::AppliedTag", dependent: :destroy
  has_many :tags, through: :applied_tags, class_name: "Items::Tag"
  has_many :options, class_name: "Items::Option", dependent: :destroy
  has_many :reservations
  # 🚅 add has_many associations above.

  has_one_attached :layout
  # 🚅 add has_one associations above.
  default_scope { where(active: true) }
  scope :active, -> { where(active: true) }
  scope :schedulable, -> { joins(:tags).where(tags: { schedulable: true }).distinct }
  # 🚅 add scopes above.

  validates :name, presence: true
  validates :location, scope: true
  validates :items_area, scope: true
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

    def ticketable?
    tags.where(ticketable: true).any?
  end

  def schedulable?
    tags.where(schedulable: true).any?
  end

  def optionable?
    tags.where(optionable: true).any?
  end

  def exclusivable?
    tags.where(exclusivable: true).any?
  end

  def cleanable?
    tags.where(cleanable: true).any?
  end

  def publicable?
    tags.where(publicable: true).any?
  end

  def valid_items_areas
    team.items_areas
  end

  def item_options
   # Item.find(self.id).options
    self.options
  end

  # 🚅 add methods above.
end
