# frozen_string_literal: true

module Layout
  class NavbarComponent < ApplicationComponent
    def initialize(nav_items: [])
      @nav_items = nav_items
    end

    private

    attr_reader :nav_items

    def user_signed_in?
      defined?(Devise) && helpers.user_signed_in?
    end

    def current_user
      helpers.current_user if user_signed_in?
    end

    def left_nav_items
      nav_items
    end

    def auth_items
      if user_signed_in?
        [
          {
            text: "Witaj, #{current_user.email.split('@').first}!",
            href: '#',
            classes: 'hidden lg:block text-sm text-gray-600 cursor-default'
          },
          {
            text: 'Moje aplikacje',
            href: dashboard_path,
            classes: 'inline-flex items-center rounded-md px-2 sm:px-3 py-2 text-xs sm:text-sm font-medium text-slate-700 hover:text-violet-600 hover:bg-violet-50 focus:outline-none focus:ring-2 focus:ring-violet-500 focus:ring-offset-2 transition-colors'
          },
          {
            text: 'Profil',
            href: helpers.edit_user_registration_path,
            classes: 'inline-flex items-center rounded-md px-2 sm:px-3 py-2 text-xs sm:text-sm font-medium text-slate-700 hover:text-violet-600 hover:bg-violet-50 focus:outline-none focus:ring-2 focus:ring-violet-500 focus:ring-offset-2 transition-colors'
          }
        ]
      else
        [
          {
            text: 'Zaloguj',
            href: helpers.new_user_session_path,
            classes: 'inline-flex items-center rounded-md px-2 sm:px-3 py-2 text-xs sm:text-sm font-medium text-slate-700 hover:text-violet-600 hover:bg-violet-50 focus:outline-none focus:ring-2 focus:ring-violet-500 focus:ring-offset-2 transition-colors'
          },
          {
            text: 'Zarejestruj',
            href: helpers.new_user_registration_path,
            classes: 'inline-flex items-center rounded-md px-2 sm:px-3 py-2 text-xs sm:text-sm font-medium bg-violet-600 text-white hover:bg-violet-700 focus:outline-none focus:ring-2 focus:ring-violet-500 focus:ring-offset-2 transition-colors'
          }
        ]
      end
    end

    def logout_button_classes
      'inline-flex items-center rounded-md px-2 sm:px-3 py-2 text-xs sm:text-sm font-medium text-red-600 hover:text-red-700 hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition-colors'
    end
  end
end
