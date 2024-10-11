FactoryBot.define do
  factory :retreats_demographic_tag, class: 'Retreats::DemographicTag' do
    retreat { nil }
    demographic { nil }
  end
end
