# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete own question', "
  In order to delete my question
  As an authenticated user
  I'd like to be able delete my question
" do

  describe 'Authenticated user' do
    scenario 'can delete own question'
    scenario "can't delete someone else's question"
  end

end
