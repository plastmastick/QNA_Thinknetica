# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :unvote
    end
  end

  resources :questions do
    concerns :votable

    resources :answers, shallow: true, only: %i[create update destroy] do
      concerns :votable

      member do
        patch :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
