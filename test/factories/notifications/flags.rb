FactoryBot.define do
  factory :notifications_flag, class: 'Notifications::Flag' do
    association :team
    name { "MyString" }
    department { nil }
  end
end
