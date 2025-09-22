# frozen_string_literal: true

require 'sidekiq/web' # for Sidekiq Web UI

Rails.application.routes.draw do
  # Static pages
  root 'pages#waitlist'
  get 'pages/home'
  get 'pages/tos'
  get 'pages/privacy'
  get 'profile', to: 'pages#profile'

  get 'up', to: 'rails/health#show', as: :rails_health_check

  # Devise routes
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # Sidekiq Web UI (admin only)
  authenticate :user, lambda(&:admin?) do
    mount Sidekiq::Web => '/sidekiq'
  end

  # User-specific routes
  namespace :users do
    resource :profile, only: %i[edit update]
  end

  resource :dashboard, only: :show, controller: 'dashboards'

  # Tasks and nested submissions
  resources :tasks, only: %i[index create show new edit update] do
    collection do
      match :wizard, via: %i[get post]
      post :authenticate_and_create
      get :create_from_session, as: :create_from_session
    end

    member do
      patch :update
      get :created
      get :completed
    end

    resources :submissions, only: %i[new create] do
      member do
        patch :accept
        patch :reject
      end
    end
  end

  # Submissions
  resources :submissions, only: %i[index show edit update destroy] do
    member do
      patch :accept
      patch :reject
      get :accepted
      get :contact
    end
    collection do
      get :create_from_session
    end
  end

  # Custom routes
  get 'my_tasks/:id', to: 'tasks#my_task', as: :my_task
end
