class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: "User", inverse_of: :author_comments

  validates :body, presence: true
end
