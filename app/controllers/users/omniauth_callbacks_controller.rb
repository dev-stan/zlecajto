# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      @user = User.from_google(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in @user, event: :authentication

        redirect_to edit_users_users_profile_path
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
    end

    def facebook
      @user = User.from_facebook(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in @user, event: :authentication

        if @user.phone_number.blank?
          redirect_to edit_users_users_profile_path
        else
          redirect_to after_sign_in_path_for(@user), notice: 'Zalogowano przez Facebook!'
        end
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      else
        session['devise.facebook_data'] = request.env['omniauth.auth'].except(:extra)
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
    end
  end
end
