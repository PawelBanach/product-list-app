# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    title { Faker::Lorem.unique.word }
  end
end
