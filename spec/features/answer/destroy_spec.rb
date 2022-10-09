# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete own answer', "
  In order to delete my answer
  As an authenticated user
  I'd like to be able delete my answer
" do

  describe 'Authenticated user' do
    scenario 'can delete own answer'
    scenario "can't delete someone else's answer"
  end

end
