# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    let!(:answer) { create(:answer) }
    let(:create_answer) do
      post :create, params: { question_id: answer.question, answer: attributes_for(:answer), format: :js }
    end

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
        expect(create_answer).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_answer) do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid), format: :js }
      end

      it 'does not save the answer' do
        expect { create_invalid_answer }.not_to change(Answer, :count)
      end

      it 're-renders show view for @question' do
        expect(create_invalid_answer).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }
    let(:destroy_answer) { delete :destroy, params: { question_id: answer.question, id: answer }, format: :js }

    describe 'Assigns' do
      before do
        login(answer.author)
        destroy_answer
      end

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

      it 'render destroy view' do
        expect(destroy_answer).to render_template :destroy
      end
    end

    it "not author of question can't delete" do
      expect { destroy_answer }.not_to change(Question, :count)
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer) }
    let!(:file) { fixture_file_upload('test_xml.xml', 'text/xml') }
    let(:update_answer) do
      patch :update, params: {
        id: answer,
        answer: { body: 'new body', files: [file] },
        format: :js
      }
      answer.reload
    end

    context 'with valid attributes and current user is author of answer' do
      before { login(answer.author) }

      it 'changes answer body' do
        update_answer
        expect(answer.body).to eq 'new body'
      end

      it 'add new files to answer' do
        update_answer
        expect(answer.files.count).to eq 2
      end

      it 'renders update view' do
        update_answer
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes and current user is author of answer' do
      let(:update_answer_invalid) do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        answer.reload
      end

      before { login(answer.author) }

      it 'does not change answer attributes' do
        expect { update_answer_invalid }.not_to change(answer, :body)
      end

      it 'renders update view' do
        update_answer_invalid
        expect(response).to render_template :update
      end
    end

    it "not author of question can't update" do
      update_answer
      expect(answer.body).to eq "MyText"
    end
  end

  describe 'PATCH #best' do
    let!(:answer) { create(:answer) }
    let!(:reward) { create(:reward, question: answer.question) }
    let(:best_answer) do
      patch :best, params: { id: answer }, format: :js
      answer.reload
    end

    describe 'Assigns' do
      before do
        login(answer.question.author)
        best_answer
      end

      it 'the answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'the question of deleted answer to @question' do
        expect(assigns(:question)).to eq answer.question
      end
    end

    context 'when current user is author of question' do
      before { login(answer.question.author) }

      it 'changes answer attributes' do
        best_answer
        expect(answer.best).to be true
      end

      it 'add new reward to answer author' do
        expect { best_answer }.to change(answer.author.rewards, :count).by(1)
      end

      it 'check reward to answer author' do
        best_answer
        expect(answer.author.rewards.last).to eq reward
      end

      it 'renders best view' do
        best_answer
        expect(response).to render_template :best
      end
    end

    it "not author of question can't select the best" do
      expect { best_answer }.to not_change(answer, :best)
    end
  end
end
