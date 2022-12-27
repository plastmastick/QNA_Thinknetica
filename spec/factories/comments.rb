# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    author
    body { 'Comment body' }

    association :commentable, factory: :question

    trait :for_answer do
      association :commentable, factory: :answer
    end
  end
end
