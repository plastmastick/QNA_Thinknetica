# frozen_string_literal: true

require 'rails_helper'

feature 'User can view his rewards', "
  In order to check my achievements
  As an authenticated user
  I'd like to be view my reward
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:reward) { create(:reward, owner: user) }

  background do
    page.driver.browser.manage.window.resize_to(3840, 2160)
    sign_in(user)
  end

  scenario 'User view list of his reward', js: true do
    visit rewards_path

    within('.rewards') do
      expect(page).to have_content reward.title
      expect(page).to have_css('img')
      expect(page).to have_content reward.question.title
    end
  end
end
