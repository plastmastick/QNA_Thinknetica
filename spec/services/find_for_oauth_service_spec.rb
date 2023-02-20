# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindForOauthService do
  subject(:service) { described_class.new(auth) }

  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }

  context 'when user has been authorized already' do
    it 'returns the user' do
      user.authorisations.create(provider: 'github', uid: '123')
      expect(service.call).to eq user
    end
  end

  context 'when user has not been authored yet' do
    context 'when user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: user.email }) }

      it_behaves_like 'Oauth Service' do
        let(:authorisation) { service.call.authorisations.first }
      end

      it 'does not create new user' do
        expect { service.call }.not_to change(User, :count)
      end

      it 'creates authorisation for user' do
        expect { service.call }.to change(user.authorisations, :count).by(1)
      end

      it 'returns the user' do
        expect(service.call).to eq user
      end
    end

    context 'when user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: 'example@email.com' }) }

      it_behaves_like 'Oauth Service' do
        let(:authorisation) { service.call.authorisations.first }
      end

      it 'creates new user' do
        expect { service.call }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(service.call).to be_a User
      end

      it 'fills up user email' do
        user = service.call
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates an authorisation for user' do
        user = service.call
        expect(user.authorisations).not_to be_empty
      end
    end
  end
end
