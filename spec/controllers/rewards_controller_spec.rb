# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe "GET #index" do
    let(:rewards) { create_list(:reward, 3) }

    before { get :index }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it 'populates an array of all questions' do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
