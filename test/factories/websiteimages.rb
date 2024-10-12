FactoryBot.define do
  factory :websiteimage do
    association :team
    name { "MyString" }
    description { "MyString" }
    image { "MyString" }
  end
end
