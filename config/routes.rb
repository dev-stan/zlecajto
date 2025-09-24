# frozen_string_literal: true

require 'sidekiq/web' # for Sidekiq Web UI

Rails.application.routes.draw do
  # Static pages
  root 'pages#waitlist'
  get 'pages/home'
  get 'pages/tos'
  get 'pages/privacy'
  get 'profile', to: 'pages#profile'
  delete 'modal', to: 'modals#destroy', as: 'close_modal'

  get 'up', to: 'rails/health#show', as: :rails_health_check

  # Devise routes
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  post '/scaler/scale_worker', to: 'sidekiq_scaler#scale'

  # # Sidekiq Web UI (admin only)
  # authenticate :user, lambda(&:admin?) do
  #   mount Sidekiq::Web => '/sidekiq'
  # end
  mount Sidekiq::Web => '/sidekiq'
  # User-specific routes
  namespace :users do
    resource :profile, only: %i[edit update]
  end

  # Task Wizard Routes (separate from CRUD)
  scope path: 'tasks' do
    get 'new', to: 'task_wizard#new', as: :new_task
    match 'wizard', to: 'task_wizard#wizard', via: %i[get post], as: :task_wizard
    post 'create', to: 'task_wizard#create', as: :create_task
    get 'create_from_session', to: 'task_wizard#create_from_session', as: :create_from_session_task
  end

  scope path: 'submissions' do
    get 'create_from_session', to: 'submissions#create_from_session', as: :create_from_session_submission
  end

  # Tasks CRUD routes
  resources :tasks, only: %i[index show edit update] do
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
      get :confirm_submission_accept
    end
    collection do
      get :create_from_session
    end
  end

  # Custom routes
  get 'my_tasks/:id', to: 'tasks#my_task', as: :my_task
end
