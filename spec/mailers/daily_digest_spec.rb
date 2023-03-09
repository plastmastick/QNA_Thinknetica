# frozen_string_literal: true

require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:mail) { described_class.digest(user) }
    let!(:user) { create(:user) }
    let!(:questions) { create_list(:question, 2) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
    end
  end
end
