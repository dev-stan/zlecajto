# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # Health check
  get 'up', to: 'rails/health#show', as: :rails_health_check

  # Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Sidekiq Web UI, only for admins
  authenticate :user, ->(u) { u.admin? } do
    post '/scaler/scale_worker', to: 'sidekiq_scaler#scale'
    mount Sidekiq::Web => '/sidekiq'
  end

  # Static pages
  root 'pages#home'
  scope controller: :pages do
    get 'pages/categories', action: :categories
    get 'pages/tos', action: :tos
    get 'pages/privacy', action: :privacy
    get 'pages/contact', action: :contact
  end

  # Authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # User profile
  namespace :users do
    resource :profile, only: %i[show edit update]
  end

  # Task wizard
  scope path: 'tasks', controller: :task_wizard do
    get 'new', action: :new, as: :new_task
    match 'wizard', action: :wizard, via: %i[get post], as: :task_wizard
    post 'create', action: :create, as: :create_task
    get 'create_from_session', action: :create_from_session, as: :create_from_session_task
  end

  # Tasks
  resources :tasks, only: %i[index show edit update destroy] do
    member do
      get :created
      get :completed
    end

    resources :task_messages, only: [:create]
    resources :submissions, only: %i[new create] do
      member do
        patch :accept
        patch :reject
      end
    end
  end
  # Submissions from session
  get 'submissions/create_from_session', to: 'submissions#create_from_session',
                                         as: :create_from_session_submission
  # Submissions
  resources :submissions, only: %i[index show edit update destroy] do
    member do
      patch :accept
      patch :reject
      get :accepted
      get :contact
    end
  end

  # Answers
  resources :answers, only: [:create]

  # Task messages from session
  get 'task_messages/create_from_session', to: 'task_messages#create_from_session',
                                           as: :create_from_session_task_message

  get 'my_tasks/:id', to: 'tasks#my_task', as: :my_task

  # Modals
  scope controller: :modals do
    get 'users/profile/choose_category', action: :choose_user_category, as: :choose_user_category_modal
    get 'users/sign_out/confirm', action: :confirm_logout, as: :confirm_user_logout
    get 'users/profile/edit_modal', action: :edit_profile, as: :edit_profile_modal
    get 'tasks/:id/edit_modal', action: :edit_task, as: :edit_task_modal
    get 'tasks/:id/confirm_complete', action: :confirm_task_complete, as: :confirm_task_complete_modal
    get 'tasks/:id/delete_modal', action: :confirm_delete_task, as: :confirm_delete_task_modal
    get 'tasks/:id/task_message_modal', action: :new_task_message, as: :new_task_message_modal
    get 'task_messages/:id/photos_modal', action: :task_message_photos, as: :task_message_photos_modal
    get 'task_messages/:id/reply_modal', action: :reply_task_message, as: :reply_task_message_modal
    get 'submissions/:id/confirm_accept', action: :confirm_submission_accept, as: :confirm_submission_accept_modal
    get 'submissions/:id/answer_modal', action: :new_answer, as: :new_answer_modal
    delete 'modal', action: :destroy, as: :close_modal
  end

  # What's new
  post 'whats_new/dismiss', to: 'whats_new#dismiss', as: :dismiss_whats_new
end
