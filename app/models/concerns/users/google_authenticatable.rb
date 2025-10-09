# frozen_string_literal: true

module Users
  module GoogleAuthenticatable
    extend ActiveSupport::Concern

    class_methods do
      # Entry point called by the Omniauth callback
      def from_google(auth)
        user = find_user_from_auth(auth)

        if user.present?
          user.link_google_auth(auth)
        else
          user = create_user_from_google(auth)
          user.attach_profile_picture_from_google(auth)
        end

        user
      end

      private

      def find_user_from_auth(auth)
        find_by(provider: auth.provider, uid: auth.uid) ||
          find_by(email: auth.info.email)
      end

      def create_user_from_google(auth)
        create(
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          provider: auth.provider,
          uid: auth.uid
        )
      end
    end

    # Instance methods

    def link_google_auth(auth)
      return if provider.present? && uid.present?

      update(provider: auth.provider, uid: auth.uid)
    end

    def attach_profile_picture_from_google(auth)
      return unless auth.info.image.present?

      profile_picture.attach(
        io: URI.open(auth.info.image),
        filename: 'profile.jpg'
      )
    end
  end
end
