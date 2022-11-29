# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.sort_by_best
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new # .build
    @question.reward = Reward.new
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

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: %i[id title image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast 'questions', ApplicationController.render(
      partial: 'questions/question',
      locals: { question: @question }
    )
  end
end
