# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  background do
    page.driver.browser.manage.window.resize_to(3840, 2160)
    sign_in(user)
    visit question_path(question)
  end

  describe 'User create answer' do
    scenario 'and adds many valid links', js: true do
      fill_in 'Your answer', with: 'My answer'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add link'

      within '.nested-fields' do
        fill_in 'Link name', with: 'My gist 2'
        fill_in 'Url', with: gist_url
      end

      click_on 'Create'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'My gist 2', href: gist_url
        expect(page).to have_content "puts 'Hello, world!"
      end
    end

    scenario 'and adds invalid links', js: true do
      fill_in 'Link name', with: 'Invalid url'
      fill_in 'Url', with: 'invalid'

      click_on 'Create'

      within '.answers' do
        expect(page).not_to have_link 'Invalid url', href: 'invalid'
        expect(page).to have_content "Links url is invalid"
      end
    end
  end

  describe 'User edit an answer', js: true do
    background do
      within '.answers-list' do
        click_on 'Edit'
        click_on 'Add link'
      end
    end

    scenario 'and add valid links' do
      within '.answers-list' do
        fill_in 'Link name', with: 'New gist'
        fill_in 'Url', with: gist_url

        click_on 'Save'

        expect(page).to have_link 'New gist', href: gist_url
        expect(page).to have_content "puts 'Hello, world!"
      end
    end

    scenario 'and add invalid links' do
      within '.answers-list' do
        fill_in 'Link name', with: 'Invalid link'
        fill_in 'Url', with: 'invalid_url'

        click_on 'Save'

        expect(page).not_to have_link 'Invalid link', href: 'invalid_url'
        expect(page).to have_content "Links url is invalid"
      end
    end
  end
end
