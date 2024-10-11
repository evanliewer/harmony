FactoryBot.define do
  factory :retreats_host_tag, class: 'Retreats::HostTag' do
    retreat { nil }
    host { nil }
  end
end
