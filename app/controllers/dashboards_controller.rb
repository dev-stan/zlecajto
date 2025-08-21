# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @tasks = current_user.tasks.includes(:submissions, :reviews).order(created_at: :desc)
    @submissions = current_user.submissions.includes(task: :user).order(created_at: :desc)
  end
end
