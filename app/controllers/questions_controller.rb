# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy delete_file]

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

    @question.update(title: question_params[:title], body: question_params[:body])
    @question.files.attach(question_params[:files]) if question_params[:files]
  end

  def destroy
    if @question.author == current_user
      @question.destroy
      redirect_to questions_path, notice: t('question.success_deleted')
    else
      render :show
    end
  end

  def delete_file
    return unless @question.files.attached? && @question.author == current_user

    @question.files.find(params[:file_id]).purge
    set_question
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
