# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url,
            format: {
              with: %r{
              \Ahttps?://(?:www\.)?[-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_+.~#?&/=]*)\z
              }x
            }

  def gist?
    url.match?(%r{gist.github.com/\w+/\w+\z})
  end
end
