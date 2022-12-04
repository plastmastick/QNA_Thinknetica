# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_user_id
  def set_user_id
    return unless current_user

    gon.user_id = current_user.id
  end
end
