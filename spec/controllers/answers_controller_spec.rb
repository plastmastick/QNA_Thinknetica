# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: answer.question, id: answer } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns the requested question of answer to @question' do
      expect(assigns(:question)).to eq answer.question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let!(:answer) { create(:answer) }

    it 'assign question of answer to @question' do
      post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }
      expect(assigns(:question)).to eq answer.question
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }
        end.to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }
        end.not_to change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
end
