# frozen_string_literal: true

class NotifierService
  # TODO: refactor for multiple subscritable models (answer & etc)
  def initialize(answer)
    @answer = answer
    @question = answer.question
  end

  def send_new_answer
    @question.subscribers.find_each do |subscriber|
      NotifierMailer.notify(@answer, subscriber).deliver_later
    end
  end
end
