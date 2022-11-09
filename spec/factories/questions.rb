# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    author { create(:user) }

    trait :invalid do
      title { nil }
    end

    after(:build) do |post|
      post.files.attach(
        io: Rails.root.join("spec/factories/questions.rb").open,
        filename: 'questions_factory.rb',
        content_type: 'application/rb'
      )
    end
  end
end
