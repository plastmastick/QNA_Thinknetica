# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to give answer to community
  As an authenticated user
  I'd like to be able to answer on question
" do

  describe 'Authenticated user' do
    scenario 'give a answer'
    scenario 'give a answer with errors'
  end

  scenario 'Unauthenticated user tries to give a answer'
end
