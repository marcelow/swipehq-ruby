require 'factory_girl'

FactoryGirl.define do
  factory :transaction, class: SwipeHQ::Transaction do
    sequence(:item){ |n| "Item #{n}" }
    sequence(:description){ |n| "Description for Item #{n}" }
    amount{ 100 }
    default_quantity{ 1 }
    user_data { { a: 1, b: 2, c: 3 }.to_json }
    currency{ 'NZD' }
  end
end
