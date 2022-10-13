# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', "
  In order to sign up to platform
  As an unregistered user
  I'd like to be able to sign up
" do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  scenario 'Registered user tries to sign up with errors' do
    fill_in 'Email', with: user.email
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(page).to have_content "Password can't be blank"
  end
end
