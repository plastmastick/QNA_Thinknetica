# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:author_questions).dependent(:nullify) }
  it { is_expected.to have_many(:author_answers).dependent(:nullify) }
  it { is_expected.to have_many(:author_comments).dependent(:nullify) }
  it { is_expected.to have_many(:rewards).dependent(:nullify) }
  it { is_expected.to have_many(:authorisations).dependent(:destroy) }
  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }

  describe '.find_for_oauth' do
    let(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      allow(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      described_class.find_for_oauth(auth)
    end
  end
end
