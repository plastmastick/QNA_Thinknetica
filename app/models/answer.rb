# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", inverse_of: :author_answers

  validates :body, presence: true
end
