# frozen_string_literal: true

Rails.application.routes.draw do
  get 'pages/home'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'pages#home'
  resources :tasks, only: %i[index create show new] do
    collection do
      match :wizard, via: %i[get post]
      post :authenticate_and_create
      get :create_from_session, as: :create_from_session
    end

    resources :submissions, only: %i[new create]
  end

  resources :submissions, only: %i[index show edit update destroy]
  resource :dashboard, only: :show, controller: 'dashboards'
end
