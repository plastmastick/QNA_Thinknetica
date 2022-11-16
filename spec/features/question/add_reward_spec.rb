# frozen_string_literal: true

require 'rails_helper'

feature 'User can add reward to question', "
  In order to motivate other user for answer on question
  As an question's author
  I'd like to be able to add reward
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  background do
    page.driver.browser.manage.window.resize_to(3840, 2160)
    sign_in(user)
  end

  scenario 'User adds link when asks question', js: true do
    visit new_question_path

    # base
    fill_in 'Title', with: 'Test question'
    fill_in 'Question', with: 'text text text'
    # reward
    fill_in 'Reward name', with: 'My reward'
    attach_file 'Reward image', Rails.root.join('spec/rails_helper.rb')

    click_on 'Ask'

    expect(page).to have_content "My reward"
    expect(page).to have_css "img"
  end
end
