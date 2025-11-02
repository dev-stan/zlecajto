# frozen_string_literal: true

module Users
  class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user
    before_action :set_role_based_on_pending_object, only: [:edit]

    def show
      if user_signed_in?
        # Tasks
        @tasks           = @user.tasks.with_submissions
        @open_tasks      = @user.tasks.open.with_submissions
        @accepted_tasks  = @user.tasks.accepted.with_submissions
        @completed_tasks = @user.tasks.completed.with_submissions
        @overdue_tasks   = @user.tasks.overdue.with_submissions
        @cancelled_tasks = @user.tasks.cancelled.with_submissions

        # Submissions
        @submissions           = @user.submissions.with_task
        @open_submissions      = @user.submissions.for_user(@user).open_submissions
        @accepted_submissions  = @user.submissions.for_user(@user).accepted_submissions
        @completed_submissions = @user.submissions.for_user(@user).completed_tasks
        @rejected_submissions  = @user.submissions.for_user(@user).rejected_for_user(@user)

        # Mark accepted submissions seen if tab is submissions
        if params[:tab] == 'submissions' && @submissions.accepted.exists?
          @user.mark_accepted_submissions_seen!
        end
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
