# frozen_string_literal: true

class LinksController < ApplicationController
  def destroy
    set_link_and_resource
    return unless @resource.links.exists? && @resource.author == current_user

    set_answers_by_best if @resource.is_a?(Answer)
    @link.destroy
    @resource.reload
  end

  private

  def set_link_and_resource
    @link = Link.find(params[:id])
    @resource = @link.linkable
  end

  def set_answers_by_best
    @answers = @resource.question.answers.sort_by_best
  end
end
