# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :set_task, only: %i[new create]
  before_action :set_recipient, only: %i[new create]

  def index
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user

    @received_reviews = @user.received_reviews
                             .includes(:author, :task)
                             .order(created_at: :desc)

    @authored_reviews = @user.authored_reviews
                             .includes(:recipient, :task)
                             .order(created_at: :desc)

    @received_average_rating = @received_reviews.average(:rating)&.round(1) || 0
    @received_reviews_count = @received_reviews.count

    @authored_average_rating = @authored_reviews.average(:rating)&.round(1) || 0
    @authored_reviews_count = @authored_reviews.count
  end

  def new
    @review = Review.new(task: @task)
  end

  def create
    @review = Review.new(review_params.merge(author: current_user, recipient: @recipient))

    if @review.save
      redirect_to user_reviews_path(current_user, tab: 'authored'), notice: t('reviews.create.success')
    else
      redirect_back fallback_location: @task,
                    alert: t('reviews.create.error', errors: @review.errors.full_messages.join(', '))
    end
  end

  private

  def set_task
    @task = if action_name == 'create'
              Task.find(review_params[:task_id])
            else
              Task.find(params[:task_id])
            end
  end

  def set_recipient
    @recipient = if @task.user_id == current_user.id
                   @task.accepted_submission&.user
                 elsif @task.accepted_submission&.user_id == current_user.id
                   @task.user
                 end

    return if @recipient

    redirect_back fallback_location: root_path, alert: t('reviews.create.failure')
  end

  def review_params
    params.require(:review).permit(:task_id, :rating, :description)
  end
end
