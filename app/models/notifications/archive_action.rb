class Notifications::ArchiveAction < ApplicationRecord

  include Actions::TargetsMany
  include Actions::ProcessesAsync
  # include Actions::SupportsScheduling
  include Actions::HasProgress
  include Actions::TracksCreator
  # include Actions::RequiresApproval
  # include Actions::CleansUp
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team, class_name: "Team"
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_targets
    team.notifications
  end


  def perform_on_target(notification)
    # This is where you implement the operation you want to perform on each target.
    notification.update(read_at: Time.zone.now)
  end

  # 🚅 add methods above.
end
