FactoryBot.define do
  factory :question do
    association :team
    name { "MyString" }
    description { "MyString" }
  end
end
