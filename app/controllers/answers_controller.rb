# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_answer, only: %i[destroy update]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def destroy
    @question = @answer.question

    if @answer.author == current_user
      @answer.destroy
      redirect_to question_path(@question), notice: t('answer.success_deleted')
    else
      render 'questions/show'
    end
  end

  def update
    @question = @answer.question
    return unless @answer.author == current_user

    @answer.update(answer_params)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
