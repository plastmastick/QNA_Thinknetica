# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to give answer to community
  As an authenticated user
  I'd like to be able to answer on question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'give a answer' do
      fill_in 'Body', with: 'textAnswer'
      click_on 'New answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'textAnswer'
    end

    scenario 'give a answer with errors' do
      click_on 'New answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give a answer' do
    visit question_path(question)
    click_on 'New answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
