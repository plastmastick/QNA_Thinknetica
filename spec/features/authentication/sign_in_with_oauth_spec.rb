# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in with oauth service', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in with oauth service
" do
  background { visit new_user_session_path }

  scenario 'Sign in with GitHub' do
    mock_auth_hash(:github, '123@user.com')
    click_on 'Sign in with GitHub'

    expect(page).to have_content('Successfully authenticated from Github account.')
    expect(page).to have_content("Log out")
  end

  describe 'Sign in with Twitter' do
    background do
      mock_auth_hash(:twitter)
      click_on 'Sign in with Twitter'
      fill_in 'user_email', with: 'test@example.com'
    end

    scenario 'signs in' do
      click_on 'Finish registration'

      expect(page).to have_content 'message with a confirmation link has been sent'
      expect(page).to have_content 'Log in'
    end

    scenario 'confirms email' do
      click_on 'Finish registration'
      open_email('test@example.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'logs in with confirmed email' do
      click_on 'Finish registration'
      open_email('test@example.com')
      current_email.click_link 'Confirm my account'
      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end
  end
end
