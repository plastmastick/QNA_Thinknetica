# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  def show
    render json: answer, serializer: AnswerSerializer
  end

  def create
    authorize! :create, Answer
    @answer = question.answers.new(answer_params)
    @answer.author = current_resource_owner
    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, answer
    if answer.update(answer_params)
      render json: answer, serializer: AnswerSerializer
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
    render json: answer, serializer: AnswerSerializer
  end

  private

  def answer
    @answer ||= Answer.with_attached_files.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy])
  end
end
