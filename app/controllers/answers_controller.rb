# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!
  before_action :set_answer, only: %i[destroy update best]
  before_action :set_question, only: %i[destroy update best]
  before_action :set_answers_by_best, only: %i[destroy update best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user

    @answer.save
    flash[:notice] = t('answer.success_created')
    publish_answer
  end

  def destroy
    return unless @answer.author == current_user

    @answer.destroy
    flash[:notice] = t('answer.success_deleted')
  end

  def update
    return unless @answer.author == current_user

    @answer.update(answer_params)
    @answer.files.attach(answer_params[:files]) if answer_params[:files]
    flash[:notice] = t('answer.success_edited')
  end

  def best
    return unless @question.author == current_user

    @answer.mark_as_best
    @question.reward&.update(owner: @answer.author)
    flash[:notice] = t('answer.best_answer_setup')
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = @answer.question
  end

  def set_answers_by_best
    @answers = @question.answers.sort_by_best
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast "questions/#{@question.id}/answers",
                                 {
                                   answer: @answer,
                                   question_author_id: @question.author.id,
                                   rendered: ApplicationController.render(
                                     partial: 'answers/answer',
                                     locals: { answer: @answer, current_user: current_user }
                                   )
                                 }
  end
end
