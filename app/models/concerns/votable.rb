module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    return 0 unless votes.exists?

    rating = 0
    votes.map { |v| rating += v.value }.last
  end
end
