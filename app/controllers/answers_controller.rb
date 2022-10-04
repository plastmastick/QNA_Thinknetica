# frozen_string_literal: true

class AnswersController < ApplicationController
  helper_method :question, :answer

  def show; end

  def new; end

  def create
    if answer.save
      redirect_to answer
    else
      render :new
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.build(answer_params)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
