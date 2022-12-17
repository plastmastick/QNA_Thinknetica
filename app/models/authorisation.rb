# frozen_string_literal: true

class Authorisation < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true
end
