# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :set_answer, only: :show

  def show; end

  def new
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
