# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      verified_user_from_cookie || reject_unauthorized_connection
    end

    def verified_user_from_cookie
      # Devise stores user id in a signed cookie
      cookies.signed[:user_id] && User.find_by(id: cookies.signed[:user_id])
    end
  end
end
