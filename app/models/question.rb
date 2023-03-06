# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: "User", inverse_of: :author_questions

  has_one :reward, dependent: :destroy

  has_many :links, dependent: :destroy, as: :linkable
  has_many :answers, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :body, :title, presence: true

  scope :for_day, -> { where('created_at > ?', 1.day.ago) }
end
