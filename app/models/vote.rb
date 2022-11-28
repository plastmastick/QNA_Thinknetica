class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validates :user, uniqueness: { scope: %i[votable_id votable_type], message: 'can vote only once for each object' }

  validate :validate_value

  private

  def validate_value
    return if [1, -1].include?(value)

    errors.add(:value, "Allow vote value: 1 or -1.")
  end
end
