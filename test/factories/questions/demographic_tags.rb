FactoryBot.define do
  factory :questions_demographic_tag, class: 'Questions::DemographicTag' do
    question { nil }
    demographic { nil }
  end
end
