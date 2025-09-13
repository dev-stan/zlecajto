# frozen_string_literal: true

Rails.application.routes.draw do
  get 'pages/home'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'pages#waitlist'
  get 'profile', to: 'pages#profile'
  resources :tasks, only: %i[index create show new update] do
    collection do
      match :wizard, via: %i[get post]
      post :authenticate_and_create
      get :create_from_session, as: :create_from_session
    end
    member do
      get :edit_modal
      patch :update
    end

    resources :submissions, only: %i[new create] do
      member do
        patch :accept
        patch :reject
      end
    end
  end

  resources :submissions, only: %i[index show edit update destroy] do
    member do
      patch :accept
      patch :reject
    end
    collection do
      get :create_from_session
    end
  end
  resource :dashboard, only: :show, controller: 'dashboards'

  # Custom route for user's own task view
  get 'my_tasks/:id', to: 'tasks#my_task', as: :my_task
end
