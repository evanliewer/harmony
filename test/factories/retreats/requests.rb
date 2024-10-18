FactoryBot.define do
  factory :retreats_request, class: 'Retreats::Request' do
    association :team
    retreat { nil }
    department { nil }
    notes { "MyString" }
  end
end
