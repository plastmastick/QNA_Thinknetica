# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like "commentable"
  it_behaves_like "votable"

  it { is_expected.to belong_to :question }
  it { is_expected.to belong_to :author }

  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }

  it 'have scope best_answers that returns all best answers' do
    create(:answer, :best)
    create(:answer)
    expect(described_class.best.count).to eq 1
  end

  it 'validate count of best answers' do
    old_answer = create(:answer, :best)
    new_answer = described_class.new(body: 'test', question: old_answer.question, author: old_answer.author, best: true)

    expect(new_answer).not_to be_valid
  end

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
