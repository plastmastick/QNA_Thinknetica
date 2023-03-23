# frozen_string_literal: true

class DailyDigestJob < ApplicationJob
  queue_as :mailer

  def perform
    DailyDigestService.new.send_digest
  end
end
