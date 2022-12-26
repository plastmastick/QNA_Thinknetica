# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindForOauthService do
  subject { described_class.new(auth) }

  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }

  context 'user has been authorized already' do
    it 'returns the user' do
      user.authorisations.create(provider: 'github', uid: '123')
      expect(subject.call).to eq user
    end
  end

  context 'user has not been authoried yet' do
    context 'user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: user.email }) }

      it 'does not create new user' do
        expect { subject.call }.not_to change(User, :count)
      end

      it 'creates authorisation for user' do
        expect { subject.call }.to change(user.authorisations, :count).by(1)
      end

      it 'creates authorisation with provider and uid' do
        authorisation = subject.call.authorisations.first

        expect(authorisation.provider).to eq auth.provider
        expect(authorisation.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: 'example@email.com' }) }

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject.call).to be_a User
      end

      it 'fills up user email' do
        user = subject.call
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates an authorisation for user' do
        user = subject.call
        expect(user.authorisations).not_to be_empty
      end

      it 'creates authorisation with provider and uid' do
        authorisation = subject.call.authorisations.first

        expect(authorisation.provider).to eq auth.provider
        expect(authorisation.uid).to eq auth.uid
      end
    end
  end
end
