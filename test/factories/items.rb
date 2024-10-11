FactoryBot.define do
  factory :item do
    association :team
    name { "MyString" }
    description { "MyString" }
    location { nil }
    active { false }
    overlap_offset { 1 }
    image_tag { "MyString" }
    clean { false }
    flip_time { 1 }
    beds { 1 }
  end
end
