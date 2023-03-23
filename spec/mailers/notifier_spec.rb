# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotifierMailer, type: :mailer do
  describe "notify" do
    let(:mail) { described_class.notify(answer, user) }
    let!(:user) { create(:user) }
    let!(:answer) { create(:answer) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
    end
  end
end
