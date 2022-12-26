# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      @user.confirm
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'something went wrong'
    end
  end

  def vkontakte
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      @user.confirm
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    else
      redirect_to root_path, alert: 'something went wrong'
    end
  end

  def twitter
    auth = request.env['omniauth.auth']
    @user = User.find_by_authorisation(auth[:provider], auth[:uid])

    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      session["devise.omniauth_data"] = User.build_twitter_auth_cookie_hash(auth)
      flash[:error] = 'You need to add an email to complete your registration.'
      render 'users/registration_email'
    end
  end
end
