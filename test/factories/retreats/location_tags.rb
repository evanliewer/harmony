FactoryBot.define do
  factory :retreats_location_tag, class: 'Retreats::LocationTag' do
    retreat { nil }
    location { nil }
  end
end
