# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete own question', "
  In order to delete my question
  As an authenticated user
  I'd like to be able delete my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'can delete own question' do
      sign_in(question.author)
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario "can't delete someone else's question" do
      sign_in(user)
      visit question_path(question)

      expect(page).not_to have_button 'Delete'
    end
  end

  scenario "Unauthenticated user can't delete question" do
    visit question_path(question)
    expect(page).not_to have_button 'Delete'
  end
end
