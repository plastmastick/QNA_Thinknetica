# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", inverse_of: :author_answers

  validates :body, presence: true
  validate :validate_best_answers_count

  scope :sort_by_best, -> { order(best: :desc) }
  scope :best, -> { where(best: true) }

  def mark_as_best
    question.answers.best.each { |answer| answer.update(best: false) } if question.answers.best.count.positive?
    update(best: true)
  end

  private

  def validate_best_answers_count
    return if best == false || question.answers.best.count.zero? || question.answers.best == self

    errors.add(:best, "A question can only have one best answer")
  end
end
