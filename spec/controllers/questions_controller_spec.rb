# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:create_question) { post :create, params: { question: attributes_for(:question) } }

    before { login(user) }

    it 'question author is current user' do
      create_question
      expect(assigns(:question).author).to eq user
    end

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { create_question }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        expect(create_question).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_question) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it 'does not save the question' do
        expect { create_invalid_question }.not_to change(Question, :count)
      end

      it 're-renders new view' do
        expect(create_invalid_question).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question) }
    let(:update_question) {
      patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
      question.reload
    }

    context 'with valid attributes and current user is author of question' do
      before do
        login(question.author)
        update_question
      end

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        expect([question.title, question.body]).to eq ['new title', 'new body']
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes and current user is author of question' do
      let(:update_question_invalid) {
        patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
        question.reload
      }

      before { login(question.author) }

      it 'does not change question' do
        expect { update_question_invalid }.to not_change(question, :title).and not_change(question, :body)
      end

      it 'renders update view' do
        update_question_invalid
        expect(response).to render_template :update
      end
    end

    context "when current user isn't author of question" do
      before { login(user) }

      it "can't update question in database" do
        expect { update_question }.to not_change(question, :title).and not_change(question, :body)
      end

      it 'renders update view' do
        update_question
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let(:delete_question) { delete :destroy, params: { id: question } }

    describe 'Author of question' do
      before { login(question.author) }

      it 'deletes his question' do
        expect { delete_question }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        expect(delete_question).to redirect_to questions_path
      end
    end

    describe 'Not author of question' do
      before { login(user) }

      it "can't delete this question" do
        expect { delete_question }.not_to change(Question, :count)
      end

      it "render show view" do
        expect(delete_question).to render_template :show
      end
    end
  end
end
