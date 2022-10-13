# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out', "
  In order to sign out to platform
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content "Signed out successfully."
  end

  scenario 'Unauthenticated user tries to sign out' do
    visit root_path
    expect(page).not_to have_content 'Log out'
  end
end
