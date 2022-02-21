# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for(
    :users,
    defaults: { format: :json }
  )

  resources :ping, only: [:index]

  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/logout' => 'auth0#logout'
end
