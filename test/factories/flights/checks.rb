FactoryBot.define do
  factory :flights_check, class: 'Flights::Check' do
    association :team
    name { "MyString" }
    retreat { nil }
    flight { nil }
    user { nil }
    completed_at { "2024-10-10 22:12:39" }
  end
end
