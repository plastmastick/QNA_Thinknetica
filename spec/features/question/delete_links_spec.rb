# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete question links', "
  In order to delete useless links from my question
  As an question's author
  I'd like to be able to delete links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:link) { create(:link, linkable: question) }
  given!(:gist) { create(:link, :gist, linkable: question) }

  background do
    page.driver.browser.manage.window.resize_to(3840, 2160)
  end

  scenario 'Unauthorized user cannot delete question links if they are not the author', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question .links' do
      expect(page).not_to have_link 'remove link'
    end
  end

  scenario 'Authorized user can delete question links if they are author', js: true do
    sign_in(question.author)
    visit question_path(question)

    within '.question' do
      click_on 'Edit'
      click_on 'remove link' # delete :link

      expect(page).not_to have_link link.name, href: link.url

      click_on 'Edit'
      click_on 'remove gist' # delete :gist

      expect(page).not_to have_content "puts 'Hello, world!"
    end
  end
end
