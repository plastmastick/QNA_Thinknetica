# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  it "successfully subscribes" do
    subscribe question_id: 1
    expect(subscription).to be_confirmed
  end

  it "rejects subscribes" do
    subscribe question_id: nil
    expect(subscription).to be_rejected
  end
end
