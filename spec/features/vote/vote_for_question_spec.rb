# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user vote the favorite question', "
  In order to vote the favorite question
  As an authenticated user
  I'd like to be able vote the favorite question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user can not vote' do
    visit question_path(question)

    expect(within('.question')).not_to have_link 'Unvote'
    expect(within('.question')).not_to have_css '#upvote'
    expect(within('.question')).not_to have_css '#downvote'
  end

  scenario 'as author of question, cannot vote for own question' do
    sign_in(question.author)
    visit question_path(question)

    expect(within('.question')).not_to have_link 'Unvote'
    expect(within('.question')).not_to have_css '#upvote'
    expect(within('.question')).not_to have_css '#downvote'
  end

  describe 'Authenticated user as not author of the question', js: true do
    background do
      page.driver.browser.manage.window.resize_to(3840, 2160)
    end

    scenario 'can upvote' do
      sign_in(user)
      visit question_path(question)
      within('.question') { find_by_id('upvote').click }

      within('.question') { expect(page).to have_content 'Rating: 1' }
    end

    scenario 'can unvote' do
      sign_in(user)
      visit question_path(question)
      within('.question') do
        find_by_id('upvote').click
        click_on 'Unvote'
      end

      within('.question') { expect(page).to have_content 'Rating: 0' }
    end

    scenario 'can downvote' do
      sign_in(user)
      visit question_path(question)
      within('.question') { find_by_id('downvote').click }

      within('.question') { expect(page).to have_content 'Rating: -1' }
    end
  end
end
