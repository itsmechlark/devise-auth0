# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for(:users)

  get 'ping' => 'ping#index'
  get 'login' => 'ping#login'
  root to: "ping#index", via: [:get, :post]
end
