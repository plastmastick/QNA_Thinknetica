# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    return 0 unless votes.any?

    rating = 0
    votes.each { |v| rating += v.value }
    rating
  end
end
