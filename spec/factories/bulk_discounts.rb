FactoryBot.define do
  factory :bulk_discount do
    percentage_discount { Faker::Number.between(from: 10, to: 50) }
    quantity_threshold { Faker::Number.between(from: 5, to: 100) }

    association :merchant
  end
end
