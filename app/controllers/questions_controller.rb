# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.sort_by_best
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.author_questions.build(question_params)

    if @question.save
      redirect_to @question, notice: t('question.success_created')
    else
      render :new
    end
  end

  def update
    return unless @question.author == current_user

    @question.update(question_params)
  end

  def destroy
    if @question.author == current_user
      @question.destroy
      redirect_to questions_path, notice: t('question.success_deleted')
    else
      render :show
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
