# frozen_string_literal: true

FactoryBot.define do
  factory :authorisation do
    user { nil }
    provider { "MyString" }
    uid { "MyString" }
  end
end
