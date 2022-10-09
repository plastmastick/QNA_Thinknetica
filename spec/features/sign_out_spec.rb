# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out', "
  In order to sign out to platform
  As an authenticated user
  I'd like to be able to sign out
" do
  scenario 'Authenticated user tries to sign out'
  scenario 'Unauthenticated user tries to sign out'
end
