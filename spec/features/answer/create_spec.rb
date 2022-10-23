# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to give answer to community
  As an authenticated user
  I'd like to be able to answer on question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      page.driver.browser.manage.window.resize_to(1920, 1080)
      sign_in(user)
      visit question_path(question)
    end

    scenario 'give a answer' do
      fill_in 'Your answer', with: 'textAnswer'
      click_on 'Create'

      within('.flash') do
        expect(page).to have_content 'Your answer successfully created.'
      end
      expect(page).to have_content 'textAnswer'
    end

    scenario 'give a answer with errors' do
      click_on 'Create'

      expect(page).to have_content "Answer can't be blank"
    end

    scenario 'give a answer with attached files' do
      fill_in 'Your answer', with: 'textAnswer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to give a answer' do
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
