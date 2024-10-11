FactoryBot.define do
  factory :organization do
    association :team
    name { "MyString" }
    website { "MyString" }
  end
end
