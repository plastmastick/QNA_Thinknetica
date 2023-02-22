# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { "ACCEPT" => 'application/json' }
  end

  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions' do
    let!(:questions) { create_list(:question, 2) }
    let!(:answers) { create_list(:answer, 3, question: questions.first) }
    let(:api_path) { '/api/v1/questions' }
    let(:question_response) { json['questions'].first }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:request_params) { { access_token: create(:access_token).token } }
    end

    context 'when authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      context 'with questions' do
        it 'returns list of questions' do
          expect(json['questions'].size).to eq 2
        end

        it_behaves_like 'API Returned Fields' do
          let(:responce_json_object) { question_response }
          let(:resource) { questions.first }
          let(:public_fields) { %w[id title body created_at updated_at] }
          let(:private_fields) { nil }
        end

        it 'contains user object' do
          expect(question_response['author']['id']).to eq questions.first.author.id
        end

        it 'contains short title' do
          expect(question_response['short_title']).to eq questions.first.title.truncate(7)
        end
      end

      context 'with answers' do
        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it_behaves_like 'API Returned Fields' do
          let(:responce_json_object) { question_response['answers'].first }
          let(:resource) { answers.first }
          let(:public_fields) { %w[id body author_id created_at updated_at] }
          let(:private_fields) { nil }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:answers) { create_list(:answer, 2, question: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    it_behaves_like 'API Authorizable' do
      let(:request_params) { { access_token: create(:access_token).token } }
    end

    context 'when authorized' do
      let(:question_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      context 'with question' do
        it_behaves_like 'API Returned Fields' do
          let(:responce_json_object) { question_response }
          let(:resource) { question }
          let(:public_fields) { %w[id title body created_at updated_at] }
          let(:private_fields) { nil }
        end

        it 'returns question' do
          expect(json.size).to eq 1
        end

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 2
        end

        it 'returns list of files' do
          expect(question_response['files'].size).to eq 1
        end

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 2
        end
      end

      context 'with answers' do
        it_behaves_like 'API Returned Fields' do
          let(:responce_json_object) { json['question']['answers'].first }
          let(:resource) { answers.first }
          let(:public_fields) { %w[id body question_id author_id created_at updated_at] }
          let(:private_fields) { nil }
        end

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 2
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :post }

    it_behaves_like 'API Authorizable' do
      let(:request_params) { { access_token: access_token.token, question: attributes_for(:question) } }
    end

    context 'when authorized' do
      context 'with valid params' do
        it 'saves a new question in the database' do
          expect do
            post api_path,
                 params: { access_token: access_token.token, question: attributes_for(:question) },
                 headers: headers
          end.to change(Question, :count).by(1)
        end

        describe 'returns question json' do
          before do
            post api_path,
                 params: { access_token: access_token.token, question: attributes_for(:question) },
                 headers: headers
          end

          it_behaves_like 'API Returned Fields' do
            let(:responce_json_object) { json['question'] }
            let(:resource) { create(:question) }
            let(:public_fields) { %w[title body] }
            let(:private_fields) { nil }
          end
        end
      end

      context 'with invalid params' do
        it 'does not save the question' do
          expect do
            post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) },
                           headers: headers
          end.not_to change(Question, :count)
        end

        it_behaves_like 'API errors returnable' do
          let(:params) { { access_token: access_token.token, question: attributes_for(:question, :invalid) } }
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable' do
      let(:access_token) { create(:access_token, resource_owner_id: question.author.id) }
      let(:request_params) { { access_token: access_token.token, id: question, question: { title: 'new title' } } }
    end

    describe 'when authorized not the question author' do
      let(:other_user) { create(:user) }
      let(:other_user_access_token) { create(:access_token, resource_owner_id: other_user.id) }

      before do
        patch api_path,
              params: { access_token: other_user_access_token.token, id: question, question: { title: 'new title' } }
      end

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
      end
    end

    describe 'when authorized question author' do
      let(:user_access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid params' do
        before do
          patch api_path,
                params: { access_token: user_access_token.token, id: question, question: { title: 'new title' } }
          question.reload
        end

        it 'update the question' do
          expect(question.title).to eq 'new title'
        end

        it_behaves_like 'API Returned Fields' do
          let(:responce_json_object) { json['question'] }
          let(:resource) { question }
          let(:public_fields) { %w[id title body created_at updated_at] }
          let(:private_fields) { nil }
        end
      end

      context 'with invalid params' do
        before do
          patch api_path, params: { access_token: user_access_token.token, id: question, question: { title: '' } }

          question.reload
        end

        it 'does not change the question' do
          expect(question.title).to eq 'MyString'
        end

        it_behaves_like 'API errors returnable' do
          let(:params) { { access_token: user_access_token.token, id: question, question: { title: '' } } }
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable' do
      let(:access_token) { create(:access_token, resource_owner_id: question.author.id) }
      let(:request_params) { { access_token: access_token.token, id: question, question: { title: 'new title' } } }
    end

    context 'when authorized' do
      describe 'not the question author' do
        let(:other_user) { create(:user) }
        let(:other_user_access_token) { create(:access_token, resource_owner_id: other_user.id) }

        it 'does not delete the question' do
          expect do
            delete api_path,
                   params: { access_token: other_user_access_token.token, id: question }
          end.not_to change(Question, :count)
        end
      end

      describe 'question author' do
        let(:user_access_token) { create(:access_token, resource_owner_id: user.id) }

        it 'destroys the question' do
          expect do
            delete api_path, params: { access_token: user_access_token.token, id: question }
          end.to change(Question, :count).by(-1)
        end
      end
    end
  end
end
