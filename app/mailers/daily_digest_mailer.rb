# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.for_day

    mail to: user.email
  end
end
