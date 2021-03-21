# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Lorem.unique.word }
    description { Faker::Lorem.sentence }
    price { Faker::Commerce.price(range: 0..100.0) }
  end
end
