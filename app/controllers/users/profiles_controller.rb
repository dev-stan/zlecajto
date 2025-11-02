# frozen_string_literal: true

module Users
  class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user
    before_action :set_role_based_on_pending_object, only: [:edit]

    def show
      if user_signed_in?
        @tasks = @user.tasks.with_submissions
        @open_tasks = @user.tasks.with_submissions.where(status: :open)
        @accepted_tasks = @user.tasks.with_submissions.where(status: :accepted)
        @completed_tasks = @user.tasks.with_submissions.where(status: :completed)
        @cancelled_tasks = @user.tasks.with_submissions.where(status: :cancelled)

        @submissions = @user.submissions.includes(task: :user)
        @open_submissions = @user.submissions
                                 .includes(task: :user)
                                 .where(status: :pending, tasks: { status: :open })
                                 .order(created_at: :desc)

        @accepted_submissions = @user.submissions
                                     .includes(task: :user)
                                     .where(status: :accepted, tasks: { status: :accepted })
                                     .order(created_at: :desc)

        @rejected_submissions = @user.submissions
                                     .includes(task: :user)
                                     .joins(:task)
                                     .where(tasks: { status: %i[accepted completed cancelled overdue] })
                                     .where.not(task_id: Submission.where(status: :accepted,
                                                                          user_id: @user.id).select(:task_id))
                                     .order(created_at: :desc)

        @completed_submissions = @user.submissions
                                      .includes(task: :user)
                                      .joins(:task)
                                      .where(status: :accepted, tasks: { status: :completed })

        return unless params[:tab] == 'submissions' && @submissions.accepted.exists?

        @user.mark_accepted_submissions_seen!
      else
        @tasks = []
        @submissions = []
      end
    end

    def edit
      @pending_object_present = [PendingTask, PendingTaskMessage, PendingSubmission].any? do |klass|
        klass.present?(session)
      end
      if (@pending_object_present || @user.role.present?) && @user.phone_number.present?
        redirect_to after_sign_in_path_for(@user)
      end
    end

    def update
      if @user.update(profile_params)
        if request.referer&.end_with?('/profile')
          redirect_to users_profile_path
        else
          redirect_to after_sign_in_path_for(@user)
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def profile_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :role, categories: [])
    end

    def set_user
      @user = current_user
    end

    def set_role_based_on_pending_object
      if PendingTask.present?(session)
        @user.update(role: 'wykonawca')
      elsif PendingTaskMessage.present?(session) || PendingSubmission.present?(session)
        @user.update(role: 'zleceniodawca')
      end
    end
  end
end
