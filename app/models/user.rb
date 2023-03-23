# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable,
         :confirmable,
         omniauth_providers: %i[github vkontakte twitter]

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
  has_many :subscriptions, dependent: :destroy

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def self.find_by_authorisation(provider, uid)
    joins(:authorisations).where(authorisations: { provider: provider, uid: uid }).first
  end

  def self.build_twitter_auth_cookie_hash(data)
    {
      provider: data.provider, uid: data.uid.to_i,
      access_token: data.credentials.token, access_secret: data.credentials.secret
    }
  end

  def subscribed_to_resource?(resource)
    subscriptions.exists?(subscriptable: resource)
  end
end
