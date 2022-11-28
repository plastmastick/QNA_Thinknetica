# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    association :user, factory: :user
    value { -1 }

    trait :for_question do
      association :votable, factory: :question
    end

    trait :for_answer do
      association :votable, factory: :answer
    end

    trait :upvote do
      association :votable, factory: :question
      value { 1 }
    end

    trait :downvote do
      association :votable, factory: :question
      value { -1 }
    end
  end
end
