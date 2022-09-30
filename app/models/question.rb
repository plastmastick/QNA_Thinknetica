# frozen_string_literal: true

class Question < ApplicationRecord
  validates :body, :title, presence: true
end
