# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question subscription in the database' do
        expect do
          post :create, params: { resource_type: question.class.name, resource_id: question.id },
                        format: :js
        end.to change(Subscription, :count).by(1)
      end

      it 'renders subscription create template' do
        post :create, params: { resource_type: question.class.name, resource_id: question.id }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question_subscription) { create(:subscription, user: user, subscriptable: question) }

    it 'destroys the question subscription from the database' do
      expect do
        delete :destroy, params: { id: question_subscription }, format: :js
      end.to change(Subscription, :count).by(-1)
    end

    it 'renders question_subscription destroy template' do
      delete :destroy, params: { id: question_subscription }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
