FactoryBot.define do
  factory :items_applied_tag, class: 'Items::AppliedTag' do
    item { nil }
    tag { nil }
  end
end
