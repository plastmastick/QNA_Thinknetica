# frozen_string_literal: true

class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorisation = Authorisation.where(provider: auth[:provider], uid: auth[:uid].to_s).first
    return authorisation.user if authorisation

    email = auth[:info][:email]
    user = User.find_by(email: email)

    unless user
      password = Devise.friendly_token[0, 10]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    create_authorisation(user, auth)
    user
  end

  private

  def create_authorisation(user, auth)
    user.authorisations.create!(provider: auth[:provider], uid: auth[:uid])
  end
end
