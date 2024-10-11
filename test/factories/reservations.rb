FactoryBot.define do
  factory :reservation do
    association :team
    name { "MyString" }
    retreat { nil }
    item { nil }
    user { nil }
    start_time { "2024-10-10 19:48:02" }
    end_time { "2024-10-10 19:48:02" }
    quantity { 1 }
    notes { "MyString" }
    seasonal_default { false }
    exclusive { false }
    active { false }
  end
end
