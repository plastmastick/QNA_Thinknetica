# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :author, class_name: "User", inverse_of: :author_questions

  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :body, :title, presence: true
end
