FactoryBot.define do
  factory :medform do
    association :team
    name { "MyString" }
    retreat { nil }
    phone { "MyString" }
    email { "MyString" }
    dietary { "MyString" }
  end
end
