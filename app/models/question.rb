# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answer, dependent: :destroy

  validates :body, :title, presence: true
end
