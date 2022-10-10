# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'GET #new' do
    before do
      login(user)
      get :new, params: { question_id: answer.question, id: answer }
    end

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
    before { login(user) }

    let!(:answer) { create(:answer) }

    it 'assign question of answer to @question' do
      post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }
      expect(assigns(:question)).to eq answer.question
    end

    it 'answer author is current user' do
      post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }
      expect(assigns(:answer).author).to eq user
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }
        end.to change(Answer, :count).by(1)
      end

      it 'redirects to show view for @question' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }
        end.not_to change(Answer, :count)
      end

      it 're-renders show view for @question' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template "questions/show"
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }
    let(:destroy_answer) { delete :destroy, params: { question_id: answer.question, id: answer } }

    describe 'Assigns' do
      before { destroy_answer }

      it 'assigns the answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the question of deleted answer to @question' do
        expect(assigns(:question)).to eq answer.question
      end
    end

    describe 'Author of answer' do
      before { login(answer.author) }

      it 'deletes his answer' do
        expect { destroy_answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to show view of @question' do
        destroy_answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    describe 'Not author of answer' do
      before { login(user) }

      it "can't delete this answer" do
        expect { destroy_answer }.not_to change(Question, :count)
      end

      it "render show show view of @question" do
        destroy_answer
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
