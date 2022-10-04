# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { Question.create!(title: "Title", body: 'Body') }

    trait :invalid do
      body { nil }
    end
  end
end
