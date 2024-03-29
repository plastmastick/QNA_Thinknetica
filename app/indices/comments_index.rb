# frozen_string_literal: true

ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body
  indexes author.email, as: :author, sortable: true

  has author_id, created_at, updated_at
end
