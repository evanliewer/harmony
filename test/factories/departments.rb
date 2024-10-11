FactoryBot.define do
  factory :department do
    association :team
    name { "MyString" }
    dashboard { false }
  end
end
