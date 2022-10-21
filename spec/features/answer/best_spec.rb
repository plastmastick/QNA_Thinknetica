# frozen_string_literal: true

require 'rails_helper'

feature 'Author of question can select the best answer', "
  In order to set the best answer
  As an author of question
  I'd like to be able select the best answer for my question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Unauthenticated user can not select best answer' do
    visit question_path(question)
    expect(within('.answers-list')).not_to have_button 'Best'
  end

  describe 'Authenticated user', js: true do
    background do
      page.driver.browser.manage.window.resize_to(1920, 1080)
      sign_in(question.author)
      answers[0].update(best: true)
      visit question_path(question)
    end

    scenario 'as the author of the question can choose the best answer', js: true do
      within("#answer-#{answers[1].id}") { click_on 'Best' }

      within first(".answer") { expect(page).to have_css "#answer-#{answers[1].id}" }
      within('.flash') { expect(page).to have_content 'Answer successfully mark as the best.' }
      within("#answer-#{answers[1].id}") { expect(page).not_to have_link 'Best' }
      within("#answer-#{answers[0].id}") { expect(page).to have_link 'Best' }
    end

    scenario 'as not the author of the question, cannot choose the best answer' do
      expect(within('.answers-list')).not_to have_button 'Best'
    end
  end
end
