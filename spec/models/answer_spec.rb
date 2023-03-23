# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like "Commentable"
  it_behaves_like "Votable"
  it_behaves_like 'Authorable'
  it_behaves_like 'Linkable'
  it_behaves_like 'Attachable'

  it { is_expected.to belong_to :question }

  it { is_expected.to validate_presence_of :body }

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

  it "notifies user after create" do
    answer = build(:answer, :with_notify_callback)
    expect(NotifierJob).to receive(:perform_later).with(answer)
    answer.save
  end
end
