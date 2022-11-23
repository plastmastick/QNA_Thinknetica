# frozen_string_literal: true

module ApplicationHelper
  def gists(resource)
    resource.links&.map { |l| l if l.gist? }&.reject(&:nil?)
  end
end
