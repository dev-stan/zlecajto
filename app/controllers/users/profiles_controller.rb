# frozen_string_literal: true

module Users
  class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def edit; end

    def update
      if @user.update(profile_params)
        redirect_to p_path, notice: 'Profil uzupełniony!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def choose_role
    end

    private

    def profile_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :role)
    end

    def set_user
      @user = current_user
    end
  end
end
