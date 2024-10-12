FactoryBot.define do
  factory :retreats_assigned_contact, class: 'Retreats::AssignedContact' do
    retreat { nil }
    contact { nil }
  end
end
