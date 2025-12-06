# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @reviews = @user.received_reviews
                      .includes(:author, :task)
                      .order(created_at: :desc)
      @average_rating = @reviews.average(:rating)&.round(1) || 0
      @reviews_count = @reviews.count
    else
      @reviews = Review.where(recipient: current_user)
                       .includes(:author, :task)
                       .order(created_at: :desc)
    end
  end

  def new
    @task = Task.find(params[:task_id])
    @review = Review.new(task: @task)
  end

  def create
    @task = Task.find(review_params[:task_id])
    recipient = determine_recipient(@task)

    unless recipient
      redirect_back fallback_location: root_path, alert: 'Nie można dodać opinii.'
      return
    end

    @review = Review.new(review_params.merge(author: current_user, recipient: recipient))

    if @review.save
      redirect_to @task, notice: 'Opinia została dodana.'
    else
      redirect_back fallback_location: @task, alert: "Nie udało się dodać opinii: #{@review.errors.full_messages.join(', ')}"
    end
  end

  private

  def determine_recipient(task)
    if task.user_id == current_user.id
      task.accepted_submission&.user
    elsif task.accepted_submission&.user_id == current_user.id
      task.user
    end
  end

  def review_params
    params.require(:review).permit(:task_id, :rating, :description)
  end
end
