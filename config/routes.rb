# frozen_string_literal: true

Rails.application.routes.draw do
  get 'attachments/destroy'
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :best
      end
    end
  end

  resources :attachments, shallow: true, only: :destroy
end
