# frozen_string_literal: true

class RewardsController < ApplicationController
  authorize_resource

  def index
    @rewards = Reward.all
  end
end
