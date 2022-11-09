# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def destroy
    set_attachment_and_record
    return unless @record.files.attached? && @record.author == current_user

    set_answers_by_best if @record.is_a?(Answer)
    @record.files.find(params[:id]).purge
    @record.reload
  end

  private

  def set_attachment_and_record
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @record = @attachment&.record
  end

  def set_answers_by_best
    @answers = @record.question.answers.sort_by_best
  end
end
