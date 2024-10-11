FactoryBot.define do
  factory :items_tag, class: 'Items::Tag' do
    association :team
    name { "MyString" }
    ticketable { false }
    schedulable { false }
    optionable { false }
    exclusivable { false }
    cleanable { false }
    publicable { false }
  end
end
