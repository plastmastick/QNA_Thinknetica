# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(within('.answers-list')).not_to have_button 'Edit'
  end

  describe 'Authenticated user' do
    describe 'edits his', js: true do
      background do
        page.driver.browser.manage.window.resize_to(1920, 1080)
        sign_in(answer.author)
        visit question_path(question)
        within('.answers-list') { click_on 'Edit' }
      end

      scenario 'answer' do
        within '.answers-list' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).not_to have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).not_to have_selector 'textarea'
        end

        within('.flash') { expect(page).to have_content 'Your answer successfully edited.' }
      end

      scenario 'answer with errors' do
        within '.answers-list' do
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_content answer.body
          expect(page).to have_selector 'textarea'
          expect(page).to have_content "Answer can't be blank"
        end
      end

      scenario 'answer with new attached files' do
        within '.answers-list' do
          fill_in 'Your answer', with: 'textAnswer'
          attach_file 'File', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
          click_on 'Save'

          expect(page).to have_link 'answers_factory.rb'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in(user)
      visit question_path(question)
      expect(within('.answers-list')).not_to have_button 'Edit'
    end
  end
end
