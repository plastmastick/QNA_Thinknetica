# frozen_string_literal: true

require 'rails_helper'

feature 'User can view questions list', "
  In order to search questions
  As an authenticated or unauthenticated user
  I'd like to be able to view questions list and open them
" do
  given!(:question) { create(:question) }

  background { visit questions_path }

  scenario 'User view questions list' do
    within '.questions-list' do
      expect(page).to have_text question.title
      expect(page).to have_link question.title.to_s
    end
  end

  scenario 'User view question page' do
    click_on question.title.to_s

    expect(page).to have_text question.title
    expect(page).to have_text question.body
    expect(page).to have_text question.author.email
  end
end
