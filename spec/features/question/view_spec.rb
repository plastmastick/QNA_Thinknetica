# frozen_string_literal: true

require 'rails_helper'

feature 'User can view questions list', "
  In order to search questions
  As an authenticated or unauthenticated user
  I'd like to be able to view questions list and open them
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  background { visit questions_path }

  scenario 'User view questions list' do
    expect(page).to have_table 'Questions'
    within_table 'Questions' do
      expect(page).to have_text question.title
      expect(page).to have_button 'Show'
    end
  end

  scenario 'User view question page' do
    within_table 'Questions' do
      click_on 'Show'
    end

    expect(page).to have_text question.title
    expect(page).to have_text question.body
    expect(page).to have_text question.author.email
  end
end
