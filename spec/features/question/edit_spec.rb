# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)
    expect(within('.question')).not_to have_button 'Edit'
  end

  describe 'Authenticated user', js: true do
    describe 'edits his' do
      background do
        sign_in(question.author)
        visit question_path(question)
        within('.question') { click_on 'Edit' }
      end

      scenario 'question' do
        within '.question' do
          fill_in 'Edit title', with: 'edited title'
          fill_in 'Edit question', with: 'edited question'
          click_on 'Save'

          expect(page).not_to have_content question.body
          expect(page).to have_content 'edited title'
          expect(page).to have_content 'edited question'
          expect(page).not_to have_selector 'textarea'
        end

        within('.flash') do
          expect(page).to have_content 'Your question successfully edited.'
        end
      end

      scenario 'question with errors' do
        within '.question' do
          fill_in 'Edit title', with: ''
          click_on 'Save'

          expect(page).to have_content question.body
          expect(page).to have_selector 'textarea'
          expect(page).to have_content "Title can't be blank"
        end

        within('.flash') do
          expect(page).not_to have_content 'Your question successfully edited.'
        end
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(user)
      visit question_path(question)
      expect(within('.question')).not_to have_button 'Edit'
    end
  end
end
