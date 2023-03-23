# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifierService do
  subject(:service) { described_class.new(answer) }

  let(:users) { create_list(:user, 2) }
  let(:answer) { create(:answer, :with_notify_callback, question: question) }
  let(:question) { create(:question, subscribers: users) }

  it 'sends new answer to subscribers' do
    question.subscribers.each do |subscriber|
      expect(NotifierMailer).to receive(:notify).with(answer, subscriber).and_call_original
    end
    service.send_new_answer
  end
end
