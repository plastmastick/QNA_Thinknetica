# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy]

  authorize_resource

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @subscription = Subscription.where(subscriptable: @question, user_id: current_user&.id).first

    gon.question_id = @question.id
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
      Subscription.create!(subscriptable: @question, user: current_user)
      redirect_to @question, notice: t('question.success_created')
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
    @question.files.attach(question_params[:files]) if question_params[:files]

    flash[:notice] = t('question.success_edited')
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: t('question.success_deleted')
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
