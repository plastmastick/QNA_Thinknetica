require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(within('.answers-list')).to_not have_button 'Edit'
  end

  describe 'Authenticated user' do

    describe 'edits his', js: true do
      background do
        sign_in(answer.author)
        visit question_path(question)
        within('.answers-list') { click_on 'Edit' }
      end

      scenario 'answer' do
        within '.answers-list' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end

        within('.flash') do
          expect(page).to have_content 'Your answer successfully edited.'
        end
      end

      scenario 'answer with errors' do
        within '.answers-list' do
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_content answer.body
          expect(page).to have_selector 'textarea'
          expect(page).to have_content "Body can't be blank"
        end

        within('.flash') do
          expect(page).not_to have_content 'Your answer successfully edited.'
        end
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in(answer.author)
      visit question_path(question)
      expect(within('.answers-list')).not_to have_button 'Edit'
    end
  end
end
