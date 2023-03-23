# frozen_string_literal: true

class NotifierJob < ApplicationJob
  queue_as :mailer

  def perform(answer)
    NotifierService.new(answer).send_new_answer
  end
end
