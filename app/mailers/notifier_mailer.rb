# frozen_string_literal: true

class NotifierMailer < ApplicationMailer
  def notify(answer, user)
    @answer = answer
    @user = user

    mail to: @user.email
  end
end
