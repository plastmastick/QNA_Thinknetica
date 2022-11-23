# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_answer, only: %i[destroy update best]
  before_action :set_question, only: %i[destroy update best]
  before_action :set_answers_by_best, only: %i[destroy update best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def destroy
    return unless @answer.author == current_user

    @answer.destroy
  end

  def update
    return unless @answer.author == current_user

    @answer.update(answer_params)
    @answer.files.attach(answer_params[:files]) if answer_params[:files]
  end

  def best
    return unless @question.author == current_user

    @answer.mark_as_best
    @question.reward&.update(owner: @answer.author)
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
end
