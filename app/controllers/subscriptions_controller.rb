# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def create
    @subscription = Subscription.create!(user: current_user, subscriptable: find_resource)
  end

  def destroy
    @subscription = current_user.subscriptions.find(params[:id])
    @subscription.destroy
  end

  private

  def find_resource
    @resource = params[:resource_type].constantize.find(params[:resource_id])
  end
end
