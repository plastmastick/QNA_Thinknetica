# frozen_string_literal: true

class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :body, :question_id, :author_id, :created_at, :updated_at, :comments, :links, :files

  def files
    object.files.map { |f| rails_blob_path(f, only_path: true) }
  end
end
