class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_google(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in @user, event: :authentication

      if @user.phone_number.blank?
        redirect_to edit_users_profile_path, notice: 'Uzupełnij numer telefonu, aby dokończyć rejestrację.'
      else
        # Use the same logic as your ApplicationController
        redirect_to after_sign_in_path_for(@user), notice: 'Zalogowano przez Google!'
      end
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path
  end
end
