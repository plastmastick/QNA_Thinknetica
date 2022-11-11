# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  background do
    page.driver.browser.manage.window.resize_to(3840, 2160)
    sign_in(user)
  end

  scenario 'User adds link when asks question', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Question', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add link'

    within '.nested-fields' do
      fill_in 'Link name', with: 'My gist 2'
      fill_in 'Url', with: gist_url
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  describe 'User edit an question', js: true do
    background { visit question_path(question) }

    scenario 'and add valid links' do
      within '.question' do
        click_on 'Edit'

        click_on 'Add link'
        within '.nested-fields' do
          fill_in 'Link name', with: 'New gist'
          fill_in 'Url', with: gist_url
        end

        click_on 'Save'

        expect(page).to have_link 'New gist', href: gist_url
      end
    end

    scenario 'and add invalid links' do
      within '.question' do
        click_on 'Edit'

        click_on 'Add link'
        within '.nested-fields' do
          fill_in 'Link name', with: 'Invalid url'
          fill_in 'Url', with: 'invalid'
        end

        click_on 'Save'

        expect(page).not_to have_link 'Invalid url', href: 'invalid'
      end
    end
  end
end
