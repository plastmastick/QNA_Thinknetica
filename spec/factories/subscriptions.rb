# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    user { nil }
    subscriptable { nil }
  end
end
