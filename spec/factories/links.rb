# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { "Google" }
    url { "https://www.google.com/" }

    trait :gist do
      name { 'Gist' }
      url { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
    end
  end
end
