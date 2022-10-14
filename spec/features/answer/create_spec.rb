# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to give answer to community
  As an authenticated user
  I'd like to be able to answer on question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      page.driver.browser.manage.window.resize_to(1920, 1080)
      sign_in(user)
      visit question_path(question)
    end

    scenario 'give a answer' do
      fill_in 'Your answer', with: 'textAnswer'
      click_on 'Create'

      within('.flash') do
        expect(page).to have_content 'Your answer successfully created.'
      end
      expect(page).to have_content 'textAnswer'
    end

    scenario 'give a answer with errors' do
      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give a answer' do
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
