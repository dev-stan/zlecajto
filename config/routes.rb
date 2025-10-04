# frozen_string_literal: true

require 'sidekiq/web' # for Sidekiq Web UI

Rails.application.routes.draw do
  # Static pages
  get 'pages/waitlist'
  root 'pages#home'
  get 'pages/tos'
  get 'pages/privacy'
  get 'pages/contact'
  get 'profile', to: 'pages#profile'

  # Confirm modals
  get 'users/sign_out/confirm', to: 'modals#confirm_logout', as: 'confirm_user_logout'
  get 'submissions/:id/confirm_accept', to: 'modals#confirm_submission_accept', as: :confirm_submission_accept_modal
  get 'tasks/:id/confirm_complete', to: 'modals#confirm_task_complete', as: :confirm_task_complete_modal
  get 'tasks/:id/delete_modal', to: 'modals#confirm_delete_task', as: :confirm_delete_task_modal

  # Edit modals
  get 'tasks/:id/edit_modal', to: 'modals#edit_task', as: :edit_task_modal
  get 'users/profile/edit_modal', to: 'modals#edit_profile', as: :edit_profile_modal

  # Close modal
  delete 'modal', to: 'modals#destroy', as: 'close_modal'

  get 'up', to: 'rails/health#show', as: :rails_health_check

  # Devise routes
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # Sidekiq autoscaler endpoint
  post '/scaler/scale_worker', to: 'sidekiq_scaler#scale'

  # Sidekiq Web UI ([todo] admin only)
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
  resources :tasks, only: %i[index show edit update destroy] do
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
