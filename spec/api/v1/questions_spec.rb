# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let!(:questions) { create_list(:question, 2) }
    let!(:answers) { create_list(:answer, 3, question: questions.first) }
    let(:api_path) { '/api/v1/questions' }
    let(:question_response) { json['questions'].first }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    before { get api_path, params: { access_token: create(:access_token).token }, headers: headers }

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    context 'with questions' do
      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq questions.first.send(attr).as_json
        end
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

      it 'returns all public fields' do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(question_response['answers'].first[attr]).to eq answers.first.send(attr).as_json
        end
      end
    end
  end
end
