# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }

    before do
      session['devise.omniauth_data'] = { 'provider' => 'twitter',
                                          'uid' => '12345',
                                          'access_token' => 'token',
                                          'access_secret' => 'secret' }
    end

    it 'finds user from oauth data' do
      expect(User).to receive(:find_for_oauth).and_return(user)

      post :create, params: { user: { email: '123@email.com' } }
    end

    context 'user persist' do
      it 'redirects to root path' do
        allow(User).to receive(:find_for_oauth).and_return(user)
        post :create, params: { user: { email: '123@email.com' } }

        expect(response).to redirect_to root_path
      end
    end

    context 'user have not been saved' do
      it 'redirects to root path' do
        allow(User).to receive(:find_for_oauth).and_return(nil)
        post :create, params: { user: { email: '123@email.com' } }

        expect(response).to redirect_to root_path
      end
    end
  end
end
