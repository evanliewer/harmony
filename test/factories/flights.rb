FactoryBot.define do
  factory :flight do
    association :team
    name { "MyString" }
    description { "MyString" }
    external { false }
    preflight { false }
    warning { 1 }
  end
end
