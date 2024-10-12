FactoryBot.define do
  factory :season do
    association :team
    name { "MyString" }
    item { nil }
    season_start { "2024-10-11 20:34:47" }
    season_end { "2024-10-11 20:34:47" }
    start_time { "2024-10-11 20:34:47" }
    end_time { "2024-10-11 20:34:47" }
    quantity { 1 }
    notes { "MyString" }
  end
end
