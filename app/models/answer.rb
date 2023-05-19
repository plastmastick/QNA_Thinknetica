# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :author, class_name: "User", inverse_of: :author_answers

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true
  validate :validate_best_answers_count

  scope :sort_by_best, -> { order(best: :desc) }
  scope :best, -> { where(best: true) }

  after_create :notify_user

  def mark_as_best
    question.answers.best.each { |answer| answer.update(best: false) } if question.answers.best.count.positive?
    update(best: true)
  end

  private

  def validate_best_answers_count
    return if best == false || question.answers.best.count.zero? || question.answers.best == self

    errors.add(:best, :uniq_best_answer)
  end

  def notify_user
    NotifierJob.perform_later(self)
  end
end
