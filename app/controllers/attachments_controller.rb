# frozen_string_literal: true

class AttachmentsController < ApplicationController
  RECORD_TYPE = {
    "Question" => Question,
    "Answer" => Answer
  }.freeze

  def destroy
    set_record
    return unless @record.files.attached? && @record.author == current_user

    set_answers_by_best if @record.is_a?(Answer)
    @record.files.find(params[:file_id]).purge
    set_record
  end

  private

  def set_record
    @record = RECORD_TYPE[params[:record_type]].find(params[:record_id])
  end

  def set_answers_by_best
    @answers = @record.question.answers.sort_by_best
  end
end
