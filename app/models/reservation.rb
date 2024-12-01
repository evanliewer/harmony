class Reservation < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.
  has_many :notifications, as: :notifiable
  belongs_to :team
  belongs_to :retreat, optional: true, touch: true
  belongs_to :item, optional: true
  belongs_to :user, class_name: "Membership", optional: true
  belongs_to :items_option, class_name: "Items::Option", optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.
   scope :with_schedule_tag, -> {joins(item: { applied_tags: :tag }).where(items_tags: { name: 'Schedule' })}
   # Scope to check if an item is currently reserved
   scope :currently_reserved, ->(item_id) { where(item_id: item_id).where('start_time <= ? AND end_time >= ?', Time.current, Time.current)}

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :retreat, scope: true
  validates :item, scope: true
  validates :user, scope: true
  before_validation :set_defaults
  validates :items_option, scope: true
  validate :no_conflicting_reservations
  validate :end_time_after_start_time
  # 🚅 add validations above.
  after_save :reservation_update_notification
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

  def self.next_meal_at(location)
    now = Time.current

    # Find the next reservation for meals at the specified location
    next_meal = joins(:retreat, :item)
      .joins(retreat: :locations) # Join through locations
      .where(items: { name: ['Breakfast', 'Lunch', 'Dinner'] }) # Filter meals
      .where('reservations.start_time > ?', now) # Future reservations
      .where(locations: { name: location }) # Match the location name
      .order('reservations.start_time ASC') # Sort by the closest time
      .first # Get the next reservation

      if next_meal
        "#{next_meal.start_time.in_time_zone('America/Los_Angeles').strftime("%A %-l:%M%P")}"
      else
        "No upcoming meal"
      end  
      
  end

  def end_time_after_start_time
    if end_time.present? && start_time.present? && end_time <= start_time
      errors.add(:end_time, 'must be after the start time')
    end
  end

  def no_conflicting_reservations  
    return unless item&.exclusivable?

    overlapping_reservations = Reservation.where(item_id: item.id)
                                          .where.not(id: id) # Exclude the current reservation for updates
                                          .where('start_time < ? AND end_time > ?', end_time, start_time)

    if overlapping_reservations.exists?
      errors.add(:start_time, 'conflicts with an existing reservation for this item. Please select a different time.')
    end
  end

  def reservation_update_notification
    Rails.logger.info 'Begin User Notifications'

    # Find the associated item and interested departments
    item = Item.find(self.item_id)
    departments = item.interested_departments                
    notification_requests = Notifications::Request.joins(:notifications_flag).where(notifications_flags: { department: departments })
                                                   .where("days_before::integer >= ?", calculate_days_before)

    # Extract user IDs from the filtered notification requests
    user_ids = notification_requests.pluck(:user_id).uniq

    # Generate notification message
    notification_message = "#{self.retreat&.organization&.name || 'Unknown Organization'} had a reservation change for #{self.item&.name || 'Unknown Item'}"

    # Iterate through user IDs to create notifications and send emails
    user_ids.each do |user_id|
      notification = Notification.create!(
                      team_id: self.team_id,
                      name: notification_message,
                      action_text: 'Reservation change',
                      user_id: user_id,
                      notifiable: self
                    )

      begin
        # Send email notification
       NotifyMailer.retreat_change_email(user_id, notification).deliver_later
       Rails.logger.info "Notification email sent successfully for user_id: #{user_id}"
      rescue StandardError => e
        # Log any errors encountered
        Rails.logger.error "Failed to send notification email for user_id: #{user_id}. Error: #{e.message}"
      end
   end

    Rails.logger.info 'End User Notifications'
  end


def calculate_days_before
    retreat_start_date = self.retreat&.arrival
    return unless retreat_start_date

    (retreat_start_date.to_date - Date.current).to_i
end




  # 🚅 add methods above.
end
