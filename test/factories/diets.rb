FactoryBot.define do
  factory :diet do
    association :team
    name { "MyString" }
  end
end
