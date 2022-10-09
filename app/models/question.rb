# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :author, class_name: "User", inverse_of: :author_questions

  has_many :answers, dependent: :destroy

  validates :body, :title, presence: true
end
