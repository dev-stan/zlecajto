# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      Rails.logger.info "ActionCable: Attempting connection..."
      self.current_user = find_verified_user
      Rails.logger.info "ActionCable: Connection established for user #{current_user.id}"
    end

    private

    def find_verified_user
      verified_user_from_cookie || reject_unauthorized_connection
    end

    def verified_user_from_cookie
      # Devise stores user id in a signed cookie
      user_id = cookies.signed[:user_id]
      Rails.logger.info "ActionCable: Cookie user_id: #{user_id.inspect}"
      user_id && User.find_by(id: user_id)
    end
  end
end
