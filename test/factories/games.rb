FactoryBot.define do
  factory :game do
    association :team
    red_score { "MyString" }
    blue_score { "MyString" }
    yellow_score { "MyString" }
    green_score { "MyString" }
  end
end
