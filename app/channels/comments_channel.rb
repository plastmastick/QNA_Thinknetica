class CommentsChannel < ApplicationCable::Channel
  def subscribed
    reject if params['question_id'].blank?
    stream_from "questions/#{params['question_id']}/comments"
  end
end
