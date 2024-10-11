FactoryBot.define do
  factory :items_option, class: 'Items::Option' do
    association :item
    name { "MyString" }
    capacity { 1 }
    image_tag { "MyString" }
  end
end
