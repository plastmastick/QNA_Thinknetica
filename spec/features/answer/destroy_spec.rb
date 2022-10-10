# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete own answer', "
  In order to delete my answer
  As an authenticated user
  I'd like to be able delete my answer
" do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user' do
    scenario 'can delete own answer' do
      sign_in(answer.author)
      visit question_path(answer.question)
      within_table 'Answers' do
        click_on 'Delete'
      end
      
      expect(page).to have_content 'Your answer successfully deleted.'
    end
    
    scenario "can't delete someone else's answer" do
      sign_in(user)
      visit question_path(answer.question)

      expect(within_table('Answers')).not_to have_button 'Delete'
    end
  end

  scenario "Unauthenticated user can't delete answer" do
    visit question_path(answer.question)
    expect(within_table('Answers')).not_to have_button 'Delete'
  end
end
