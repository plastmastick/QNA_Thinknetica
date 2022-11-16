# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    title { "MyString" }
    question { create(:question) }

    after(:build) do |post|
      post.image.attach(
        io: Rails.root.join("spec/fixtures/files/test_img.png").open,
        filename: 'test_img.png',
        content_type: 'application/image'
      )
    end
  end
end
