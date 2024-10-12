FactoryBot.define do
  factory :notification do
    association :team
    name { "MyString" }
    user { nil }
    read_at { "2024-10-11 18:20:09" }
    action_text { "MyString" }
    emailed { false }
  end
end
