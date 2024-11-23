class Reservation < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :retreat, optional: true
  belongs_to :item, optional: true
  belongs_to :user, class_name: "Membership", optional: true
  belongs_to :items_option, class_name: "Items::Option", optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.
   scope :with_schedule_tag, -> {joins(item: { applied_tags: :tag }).where(items_tags: { name: 'Schedule' })}

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :retreat, scope: true
  validates :item, scope: true
  validates :user, scope: true
  before_validation :set_defaults
  validates :items_option, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.


  def valid_retreats
    team.retreats
  end

  def valid_items
    team.items.where(active: true).order(:name)
  end

  def valid_users
    team.memberships.current_and_invited
  end

  def set_defaults
    puts "set_defaults"
    self.name ||= self.retreat.name + " " + self.item.name
    self.quantity ||= 1
    self.active ||= true
  end 

def valid_items_no_rooms_or_meetings_old
  team.items
    .joins(:tags)
    .where.not(
      id: team.items.joins(:tags).where(tags: { name: ["Lodging", "Meeting Space"] }).pluck(:id)
    )
    .order(:name)
    .distinct
end

def valid_items_no_rooms_or_meetings
  team.items.schedulable.order(:name)
end


  def valid_items_options
    self.item.options
  end

  # 🚅 add methods above.
end
