# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_user_id
  def set_user_id
    gon.user_id = current_user ? current_user.id : nil
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def renderer
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, { "HTTP_HOST" => "localhost:3000",
                                            "HTTPS" => "off",
                                            "REQUEST_METHOD" => "GET",
                                            "SCRIPT_NAME" => "",
                                            "warden" => warden })
    renderer
  end
end
