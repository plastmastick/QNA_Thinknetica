# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :owner, class_name: "User", inverse_of: :rewards, optional: true

  has_one_attached :image

  validates :title, presence: true
end
