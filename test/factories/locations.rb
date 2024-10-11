FactoryBot.define do
  factory :location do
    association :team
    name { "MyString" }
    initials { "MyString" }
    capacity { 1 }
    hex_color { "MyString" }
    active { "MyString" }
  end
end
