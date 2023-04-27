# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let!(:questions) { create_list(:question, 2) }
  let(:search_query) { questions[0].body }

  describe 'POST #search' do
    it 'populates an array of found result' do
      expect(questions[0].class).to receive(:search).with(search_query)
      post :search, params: { search_type: 'question', search_query: search_query }
    end

    it 'renders result view' do
      post :search, params: { search_type: 'question', search_query: search_query }
      expect(response).to render_template :result
    end
  end
end
