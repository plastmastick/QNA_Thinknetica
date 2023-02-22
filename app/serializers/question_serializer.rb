# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :body, :comments, :links, :files, :author_id, :created_at, :updated_at
  has_many :answers

  def files
    object.files.map { |f| rails_blob_path(f, only_path: true) }
  end
end
