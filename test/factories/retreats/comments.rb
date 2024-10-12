FactoryBot.define do
  factory :retreats_comment, class: 'Retreats::Comment' do
    association :retreat
    name { "MyString" }
    user { nil }
  end
end
