# frozen_string_literal: true

require 'rails_helper'

feature 'User can view answers list', "
  In order to search answers on questions
  As an authenticated or unauthenticated user
  I'd like to be able to view answers on question
" do
  given(:answer) { create(:answer) }

  background { visit question_path(answer.question) }

  scenario 'User view answers list' do
    expect(page).to have_table 'Answers'
    within_table 'Answers' do
      expect(page).to have_text answer.body
      expect(page).to have_text answer.author.email
    end
  end
end
