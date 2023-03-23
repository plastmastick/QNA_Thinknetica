# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { create(:question) }
    author { create(:user) }
    best { false }

    before(:build) { |answer| answer.skip_callback(:create, :after, :notify_user) }

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end

    trait :with_notify_callback do
      before(:build) { |answer| answer.class.set_callback(:create, :after, :notify_user) }
    end

    after(:build) do |post|
      post.files.attach(
        io: Rails.root.join("spec/factories/answers.rb").open,
        filename: 'answers_factory.rb',
        content_type: 'application/rb'
      )
    end
  end
end
