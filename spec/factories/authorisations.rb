# frozen_string_literal: true

FactoryBot.define do
  factory :authorisation do
    user { nil }
    provider { "MyString" }
    uid { "MyString" }
  end

  trait :for_twitter do
    provider { 'twitter' }
    uid { '12345' }
  end
end
