# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answer links', "
  In order to delete useless links from my answer
  As an answer's author
  I'd like to be able to delete links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link, linkable: answer) }
  given!(:gist) { create(:link, :gist, linkable: answer) }

  background do
    page.driver.browser.manage.window.resize_to(3840, 2160)
  end

  scenario 'Unauthorized user cannot delete answer links if they are not the author', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers-list .links' do
      expect(page).not_to have_link 'remove link'
    end
  end

  scenario 'Authorized user can delete answer links if they are author', js: true do
    sign_in(answer.author)
    visit question_path(question)

    within '.answers-list' do
      click_on 'Edit'
      click_on 'remove link' # delete :link

      expect(page).not_to have_link link.name, href: link.url

      click_on 'Edit'
      click_on 'remove gist' # delete :gist

      expect(page).not_to have_content "puts 'Hello, world!"
    end
  end
end
