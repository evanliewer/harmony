FactoryBot.define do
  factory :retreats_planner_tag, class: 'Retreats::PlannerTag' do
    retreat { nil }
    planner { nil }
  end
end
