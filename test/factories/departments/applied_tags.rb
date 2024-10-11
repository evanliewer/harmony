FactoryBot.define do
  factory :departments_applied_tag, class: 'Departments::AppliedTag' do
    department { nil }
    tag { nil }
  end
end
