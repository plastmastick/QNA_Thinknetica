# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:author] do
    sequence(:email) { |n| "user#{n}@test.com" }

    password { '1234567890' }
    password_confirmation { '1234567890' }
  end
end
