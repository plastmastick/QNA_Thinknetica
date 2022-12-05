# frozen_string_literal: true

module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[create_comment]
    before_action :authenticate_user!, only: :create_comment
  end

  def create_comment
    @comment = @commentable.comments.build(comment_params)
    @comment.author = current_user

    if @comment.save
      publish_comment
    else
      render 'comments/create'
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast "questions/#{question_id}/comments",
                                 {
                                   resource: @commentable.class.name&.downcase,
                                   id: @commentable.id,
                                   rendered: ApplicationController.render(
                                     partial: 'comments/comment',
                                     locals: { comment: @comment }
                                   )
                                 }
  end

  def question_id
    @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id
  end
end
