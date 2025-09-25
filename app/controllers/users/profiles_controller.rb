# frozen_string_literal: true

class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
  redirect_to profile_path, notice: 'Profil uzupełniony!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
  params.require(:user).permit(:first_name, :last_name, :email, :phone_number)
  end
end
