# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
    defaults: { format: :json }

  resources :ping, only: [:index]
end
