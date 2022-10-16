# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { create(:question) }
    author { create(:user) }
    best { false }

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end
  end
end
