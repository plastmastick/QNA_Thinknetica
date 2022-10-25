# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :best
      end
    end
  end

  resources :attachments, only: :destroy
end
