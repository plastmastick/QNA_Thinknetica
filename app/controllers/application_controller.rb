# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_user_id
  def set_user_id
    gon.user_id = current_user ? current_user.id : nil
  end
end
