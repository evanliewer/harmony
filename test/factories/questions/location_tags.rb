FactoryBot.define do
  factory :questions_location_tag, class: 'Questions::LocationTag' do
    question { nil }
    location { nil }
  end
end
