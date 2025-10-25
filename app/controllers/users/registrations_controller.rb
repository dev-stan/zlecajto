# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up,
                                        keys: [:first_name, :last_name, :profile_picture, :phone_number,
                                               { superpowers: [] }])
      devise_parameter_sanitizer.permit(:account_update,
                                        keys: [:first_name, :last_name, :profile_picture, :phone_number,
                                               { superpowers: [] }])
    end

    def after_sign_up_path_for(_resource)
      edit_users_users_profile_path
    end
  end
end
