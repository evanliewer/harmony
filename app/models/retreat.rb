class Retreat < ApplicationRecord
  has_paper_trail
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.
  has_many :notifications, as: :notifiable
  belongs_to :team
  belongs_to :organization, optional: true
  # 🚅 add belongs_to associations above.

  has_many :location_tags, class_name: "Retreats::LocationTag", dependent: :destroy
  has_many :locations, through: :location_tags
  has_many :demographic_tags, class_name: "Retreats::DemographicTag", dependent: :destroy
  has_many :demographics, through: :demographic_tags
  has_many :planner_tags, class_name: "Retreats::PlannerTag", dependent: :destroy
  has_many :planners, through: :planner_tags, class_name: "Membership"
  has_many :host_tags, class_name: "Retreats::HostTag", dependent: :destroy
  has_many :hosts, through: :host_tags, class_name: "Membership"
  has_many :assigned_contacts, class_name: "Retreats::AssignedContact", dependent: :destroy
  has_many :contacts, through: :assigned_contacts, class_name: "Organizations::Contact"
  has_many :reservations, dependent: :destroy
  has_many :comments, class_name: "Retreats::Comment", dependent: :destroy
  has_many :requests, class_name: "Retreats::Request", dependent: :destroy
  has_many :flights_checks, class_name: "Flights::Check", dependent: :destroy
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.
  #default_scope { where(active: true) }
  scope :search_by_id_or_name, ->(query) {
    query = query.to_s.strip
      if query.match?(/^\d+$/) # Check if the query is numeric
        where('id = ? OR name ILIKE ?', query.to_i, "%#{query}%")
      else
        where('name ILIKE ?', "%#{query}%")
      end
    }
  # 🚅 add scopes above.

  validates :name, presence: true
  validates :organization, scope: true
  # 🚅 add validations above.
  after_update :notify_group_size_changes
  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def actual_count
    guest_count || actual_group_size
  end

  def valid_organizations
    team.organizations
  end

  def valid_locations
    team.locations
  end

  def valid_demographics
    team.demographics
  end

  def valid_planners
    #team.memberships.where("memberships.role_ids @> ?", '["planner"]')
    team.memberships.current_and_invited
  end

  def valid_hosts
  #  team.memberships.where("memberships.role_ids @> ?", '["host"]')
    team.memberships.current_and_invited
  end

  def valid_contacts
    team.organizations_contacts
  end

  def notify_group_size_changes
    @change = nil
    # Check for changes in `actual_group_size` first
    if saved_change_to_actual_group_size?
      old_value, new_value = saved_change_to_actual_group_size
      @change = "#{self.organization&.name} changed guest count from #{old_value} to #{new_value}"
    elsif saved_change_to_guest_count?
      # Check for changes in `guest_count` only if `actual_group_size` didn't change
      old_value, new_value = saved_change_to_guest_count
      @change = "#{self.organization&.name} changed guest count from #{old_value} to #{new_value}"
    end

    # Send the notification if there is a change
    if @change
      notification_requests = Notifications::Request.joins(:notifications_flag).where(notifications_flags: { name: "Group Size Changed" })
                                                   .where("days_before::integer >= ?", calculate_days_before)

      user_ids = notification_requests.pluck(:user_id).uniq
      user_ids.each do |user_id|
      notification = Notification.create!(
                      team_id: self.team_id,
                      name: @change,
                      action_text: 'Reservation change',
                      user_id: user_id,
                      notifiable: self
                    )

      begin
        # Send email notification
        puts "2222222222222222222222222222222"
       NotifyMailer.group_size_changed_email(user_id, notification).deliver_later
       Rails.logger.info "Notification email sent successfully for user_id: #{user_id}"
      rescue StandardError => e
        # Log any errors encountered
        Rails.logger.error "Failed to send notification email for user_id: #{user_id}. Error: #{e.message}"
      end
   end

      
    end
  end

  def calculate_days_before
    retreat_start_date = self.arrival
    return unless retreat_start_date

    (retreat_start_date.to_date - Date.current).to_i
end



  # 🚅 add methods above.
end
