# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifierJob, type: :job do
  let(:service) { instance_double(NotifierService) }
  let(:answer) { create(:answer, :with_notify_callback) }

  before do
    allow(NotifierService).to receive(:new).with(answer).and_return(service)
  end

  it 'calls NotifierService#send_new_answer' do
    expect(service).to receive(:send_new_answer)
    described_class.perform_now(answer)
  end
end
