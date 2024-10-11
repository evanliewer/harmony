FactoryBot.define do
  factory :retreat do
    association :team
    name { "MyString" }
    description { "MyString" }
    arrival { "2024-10-10 19:10:57" }
    departure { "2024-10-10 19:10:57" }
    guest_count { 1 }
    organization { nil }
    internal { false }
    active { false }
    jotform { "MyString" }
  end
end
