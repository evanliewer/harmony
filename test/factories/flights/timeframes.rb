FactoryBot.define do
  factory :flights_timeframe, class: 'Flights::Timeframe' do
    association :team
    name { "MyString" }
  end
end
