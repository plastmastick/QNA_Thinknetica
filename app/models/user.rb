# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :author_questions,
           class_name: "Question",
           foreign_key: :author_id,
           dependent: :nullify,
           inverse_of: :author

  has_many :author_answers,
           class_name: "Answer",
           foreign_key: :author_id,
           dependent: :nullify,
           inverse_of: :author

  has_many :author_comments,
           class_name: "Comment",
           foreign_key: :author_id,
           dependent: :nullify,
           inverse_of: :author

  has_many :rewards, foreign_key: :owner_id, dependent: :nullify, inverse_of: :owner
  has_many :authorisations, dependent: :destroy

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end
end
