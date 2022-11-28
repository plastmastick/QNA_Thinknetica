# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user vote the favorite answer', "
  In order to vote the favorite answer
  As an authenticated user
  I'd like to be able vote the favorite answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user can not vote' do
    visit question_path(question)

    expect(within('.answers-list')).not_to have_link 'Unvote'
    expect(within('.answers-list')).not_to have_css '#upvote'
    expect(within('.answers-list')).not_to have_css '#downvote'
  end

  scenario 'as author of answer, cannot vote for own answer' do
    sign_in(answer.author)
    visit question_path(question)

    expect(within('.answers-list')).not_to have_link 'Unvote'
    expect(within('.answers-list')).not_to have_css '#upvote'
    expect(within('.answers-list')).not_to have_css '#downvote'
  end

  describe 'Authenticated user as not author of the answer', js: true do
    background do
      page.driver.browser.manage.window.resize_to(3840, 2160)
    end

    scenario 'can upvote' do
      sign_in(user)
      visit question_path(question)
      within('.answers-list') { find('#upvote').click }

      within('.answers-list') { expect(page).to have_content 'Rating: 1' }
    end

    scenario 'can unvote' do
      sign_in(user)
      visit question_path(question)
      within('.answers-list') do
        find('#upvote').click
        click_on 'Unvote'
      end

      within('.answers-list') { expect(page).to have_content 'Rating: 0' }
    end

    scenario 'can downvote' do
      sign_in(user)
      visit question_path(question)
      within('.answers-list') { find('#downvote').click }

      within('.answers-list') { expect(page).to have_content 'Rating: -1' }
    end
  end
end
