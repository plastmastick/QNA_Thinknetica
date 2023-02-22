# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { "ACCEPT" => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
      let(:request_params) { { access_token: create(:access_token).token } }
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Returned Fields' do
        let(:responce_json_object) { json['user'] }
        let(:resource) { me }
        let(:public_fields) { %w[id email admin created_at updated_at] }
        let(:private_fields) { %w[password encrypted_password] }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
      let(:request_params) { { access_token: create(:access_token).token } }
    end

    context 'when authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: users.last.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Returned Fields' do
        let(:responce_json_object) { json['users'].first }
        let(:resource) { users.first }
        let(:public_fields) { %w[id email admin created_at updated_at] }
        let(:private_fields) { %w[password encrypted_password] }
      end

      it 'returns list of user without current resource owner' do
        expect(json['users'].size).to eq 2
      end
    end
  end
end
