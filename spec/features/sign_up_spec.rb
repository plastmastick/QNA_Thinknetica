# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', "
  In order to sign up to platform
  As an unregistered user
  I'd like to be able to sign up
" do
  scenario 'Unregistered user tries to sign up'
  scenario 'Registered user tries to sign up'
end
