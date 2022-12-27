# frozen_string_literal: true

class AccountsController < ApplicationController
  skip_authorization_check
  def create
    user = User.find_for_oauth(user_data)

    if user&.persisted?
      flash[:notice] = I18n.t "devise.registrations.signed_up_but_unconfirmed"
      redirect_to root_path
    else
      redirect_to root_path, alert: 'something went wrong'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def user_data
    data = {}
    data[:provider] = session['devise.omniauth_data']['provider']
    data[:uid] = session['devise.omniauth_data']['uid']
    data[:info] = { email: user_params[:email] }
    data
  end
end
