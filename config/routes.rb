# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    member do
      delete :delete_file
    end

    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :best
        delete :delete_file
      end
    end
  end
end
