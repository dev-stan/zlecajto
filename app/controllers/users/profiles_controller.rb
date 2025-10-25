# frozen_string_literal: true

module Users
  class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user
    before_action :set_role_based_on_pending_object, only: [:edit]

    def show
      @user = current_user
      if user_signed_in?
        @tasks = current_user.tasks.includes(:submissions).order(created_at: :desc)
        @submissions = current_user.submissions.includes(task: :user).order(created_at: :desc)
        return unless params[:tab] == 'submissions' && @submissions.accepted.exists?

        current_user.mark_accepted_submissions_seen!
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
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :role)
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
