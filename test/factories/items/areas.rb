FactoryBot.define do
  factory :items_area, class: 'Items::Area' do
    association :team
    name { "MyString" }
    location { nil }
  end
end
