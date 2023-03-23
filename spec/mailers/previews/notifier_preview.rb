# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notifier
class NotifierPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notifier/notify
  def notify
    NotifierMailer.notify
  end
end
