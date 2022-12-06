# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:author_questions).dependent(:nullify) }
  it { is_expected.to have_many(:author_answers).dependent(:nullify) }
  it { is_expected.to have_many(:author_comments).dependent(:nullify) }
  it { is_expected.to have_many(:rewards).dependent(:nullify) }
end
