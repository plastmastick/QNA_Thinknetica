# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    user { create(:user) }
    subscriptable { create(:question) }
  end
end
