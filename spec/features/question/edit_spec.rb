# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario 'can not edit question' do
      expect(within('.question')).not_to have_button 'Edit'
    end

    scenario "don't see link for delete file" do
      within('.question-files') { expect(page).not_to have_link 'Delete' }
    end
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
      end

      scenario 'question with new attached files' do
        within '.question' do
          attach_file 'File', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
          click_on 'Save'

          expect(page).to have_link 'questions_factory.rb'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'question and delete attached files' do
        within '.question-files' do
          click_link 'Delete'

          expect(page).not_to have_link 'questions_factory.rb'
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
