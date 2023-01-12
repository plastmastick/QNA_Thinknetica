# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: "questions#index"

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :unvote
    end
  end

  concern :commentable do
    member do
      post :create_comment
    end
  end

  resources :questions do
    concerns %i[votable commentable]

    resources :answers, shallow: true, only: %i[create update destroy] do
      concerns %i[votable commentable]

      member do
        patch :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  resources :accounts, only: [:create]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get 'me', on: :collection
      end

      # resources :questions, only: [:index, :show, :create, :update, :destroy] do
      #   resources :answers, shallow: true, only: [:show, :create, :update, :destroy]
      # end
    end
  end

  mount ActionCable.server => '/cable'
end
