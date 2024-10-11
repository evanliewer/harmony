FactoryBot.define do
  factory :organizations_contact, class: 'Organizations::Contact' do
    association :team
    first_name { "MyString" }
    last_name { "MyString" }
    job_title { "MyString" }
    primary_phone { "MyString" }
    email { "MyString" }
  end
end
