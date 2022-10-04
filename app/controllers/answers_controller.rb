# frozen_string_literal: true

class AnswersController < ApplicationController
  expose :question
  expose :answer, -> { params[:id] ? Answer.find(params[:id]) : question.answers.build(answer_params) }

  def create
    if answer.save
      redirect_to answer
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
