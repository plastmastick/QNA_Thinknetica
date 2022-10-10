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
    let!(:answer) { create(:answer) }
    let(:create_answer) { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) } }

    before { login(user) }

    describe 'check answer attributes' do
      before { create_answer }

      it 'assign question of answer to @question' do
        expect(assigns(:question)).to eq answer.question
      end

      it 'answer author is current user' do
        expect(assigns(:answer).author).to eq user
      end
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { create_answer }.to change(Answer, :count).by(1)
      end

      it 'redirects to show view for @question' do
        expect(create_answer).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_answer) do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }
      end

      it 'does not save the answer' do
        expect { create_invalid_answer }.not_to change(Answer, :count)
      end

      it 're-renders show view for @question' do
        expect(create_invalid_answer).to render_template "questions/show"
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }
    let(:destroy_answer) { delete :destroy, params: { question_id: answer.question, id: answer } }

    describe 'Assigns' do
      before { destroy_answer }

      it 'the answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'the question of deleted answer to @question' do
        expect(assigns(:question)).to eq answer.question
      end
    end

    context "when current user is a author of answer" do
      before { login(answer.author) }

      it 'delete his answer from database' do
        expect { destroy_answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to show view of @question' do
        expect(destroy_answer).to redirect_to question_path(assigns(:question))
      end
    end

    context "when current user isn't author of answer" do
      before { login(user) }

      it "doesn't delete answer from database" do
        expect { destroy_answer }.not_to change(Question, :count)
      end

      it "render show view of @question" do
        expect(destroy_answer).to render_template 'questions/show'
      end
    end
  end
end
