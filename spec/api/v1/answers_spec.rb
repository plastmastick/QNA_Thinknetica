# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let!(:links) { create_list(:link, 2, linkable: answer) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }

    it_behaves_like 'API Authorizable' do
      let(:request_params) { { access_token: create(:access_token).token } }
    end

    context 'when authorized' do
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns answer' do
        expect(json.size).to eq 1
      end

      it_behaves_like 'API Returned Fields' do
        let(:responce_json_object) { answer_response }
        let(:resource) { answer }
        let(:public_fields) { %w[id body author_id created_at updated_at] }
        let(:private_fields) { nil }
      end

      it 'return list of links' do
        expect(answer_response['links'].size).to eq 2
      end

      it 'return list of files' do
        expect(answer_response['files'].size).to eq 1
      end

      it 'return list of comments' do
        expect(answer_response['comments'].size).to eq 2
      end
    end
  end

  describe 'POST /api/v1/questions/question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :post }

    it_behaves_like 'API Authorizable' do
      let(:request_params) { { access_token: create(:access_token).token, answer: attributes_for(:answer) } }
    end

    context 'when authorized with valid params' do
      it 'saves a new answer in the database' do
        expect do
          post api_path,
               params: { access_token: access_token.token, answer: attributes_for(:answer) },
               headers: headers
        end.to change(Answer, :count).by(1)
      end
    end

    context 'when authorized and returns answer json' do
      before do
        post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers
      end

      it_behaves_like 'API Returned Fields' do
        let(:responce_json_object) { json['answer'] }
        let(:resource) { create(:answer) }
        let(:public_fields) { %w[body] }
        let(:private_fields) { nil }
      end
    end

    context 'when authorized with invalid params' do
      it 'does not save the answer' do
        expect do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) },
                         headers: headers
        end.not_to change(Answer, :count)
      end

      it_behaves_like 'API errors returnable' do
        let(:params) { { access_token: access_token.token, answer: attributes_for(:answer, :invalid) } }
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, author: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable' do
      let(:access_token) { create(:access_token, resource_owner_id: answer.author.id) }
      let(:request_params) { { access_token: access_token.token, id: answer, answer: { body: 'new body' } } }
    end

    context 'when authorized as not the answer author' do
      let(:other_user) { create(:user) }
      let(:other_user_access_token) { create(:access_token, resource_owner_id: other_user.id) }

      before do
        patch api_path,
              params: { access_token: other_user_access_token.token, id: answer, answer: { body: 'new body' } }
      end

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end
    end

    context 'when authorized as answer author' do
      let(:user_access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid params' do
        before do
          patch api_path, params: { access_token: user_access_token.token, id: answer, answer: { body: 'new body' } }
          answer.reload
        end

        it 'update the answer' do
          expect(answer.body).to eq 'new body'
        end

        it_behaves_like 'API Returned Fields' do
          let(:responce_json_object) { json['answer'] }
          let(:resource) { answer }
          let(:public_fields) { %w[id body created_at updated_at] }
          let(:private_fields) { nil }
        end
      end

      context 'with invalid params' do
        before do
          patch api_path, params: { access_token: user_access_token.token, id: answer, answer: { body: '' } }

          answer.reload
        end

        it 'does not change the answer' do
          expect(answer.body).to eq 'MyText'
        end

        it_behaves_like 'API errors returnable' do
          let(:params) { { access_token: user_access_token.token, id: answer, answer: { body: '' } } }
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, author: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable' do
      let(:access_token) { create(:access_token, resource_owner_id: answer.author.id) }
      let(:request_params) { { access_token: access_token.token, id: answer } }
    end

    context 'when authorized' do
      describe 'as not the answer author' do
        let(:other_user) { create(:user) }
        let(:other_user_access_token) { create(:access_token, resource_owner_id: other_user.id) }

        it 'does not delete the answer' do
          expect do
            delete api_path, params: { access_token: other_user_access_token.token, id: answer }
          end.not_to change(Answer, :count)
        end
      end

      describe 'as answer author' do
        let(:user_access_token) { create(:access_token, resource_owner_id: user.id) }

        it 'destroys the answer' do
          expect do
            delete api_path,
                   params: { access_token: user_access_token.token, id: answer }
          end.to change(Answer, :count).by(-1)
        end
      end
    end
  end
end
