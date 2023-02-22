# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: question, serializer: QuestionSerializer
  end

  def create
    authorize! :create, Question
    @question = Question.new(question_params)
    @question.author = current_resource_owner

    if @question.save
      render json: @question, serializer: QuestionSerializer
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, question
    if question.update(question_params)
      render json: question, serializer: QuestionSerializer
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, question
    question.destroy
    render json: question, serializer: QuestionSerializer
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: %i[id title image])
  end
end
