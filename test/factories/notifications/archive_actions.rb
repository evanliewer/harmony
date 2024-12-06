FactoryBot.define do
  factory :notifications_archive_action, class: "Notifications::ArchiveAction" do
    association :team, factory: :team
    scheduled_for { "2021-08-31 20:37:40" }
    started_at { "2021-08-31 20:37:40" }
    completed_at { "2021-08-31 20:37:40" }
  end
end
