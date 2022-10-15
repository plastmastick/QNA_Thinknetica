# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_answer, only: %i[destroy update]
  before_action :set_question, only: %i[destroy update]

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
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
