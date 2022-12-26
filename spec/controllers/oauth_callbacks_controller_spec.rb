# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { { 'provider' => 'github', 'uid' => '123' } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)

      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'does not login user if he does not exist' do
        expect(subject.current_user).not_to be
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'Twitter' do
    let(:oauth_data) { mock_auth_hash(:twitter) }

    before { @request.env["omniauth.auth"] = mock_auth_hash(:twitter) }

    it 'finds user by oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)

      expect(User).to receive(:find_by_authorisation).with(oauth_data.provider, oauth_data.uid)
      get :twitter
    end

    context 'user exists and confirmed his email' do
      let(:user) { create(:user) }

      before do
        allow(User).to receive(:find_by_authorisation)
          .with(oauth_data.provider, oauth_data.uid)
          .and_return(user)
        get :twitter
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exists or did not confirm his email' do
      before do
        allow(User).to receive(:find_by_authorisation)
          .with(oauth_data.provider, oauth_data.uid)
          .and_return(nil)
        get :twitter
      end

      it 'writes user credentials in session' do
        expect(User).to receive(:build_twitter_auth_cookie_hash).with(oauth_data)
        expect(session['devise.omniauth_data']).to be_present

        get :twitter
      end

      it 'renders email confirmation page' do
        allow(User).to receive(:build_twitter_auth_cookie_hash).with(oauth_data)

        expect(response).to render_template 'users/registration_email'
        expect(session['devise.omniauth_data']).to be_present
      end
    end
  end
end
