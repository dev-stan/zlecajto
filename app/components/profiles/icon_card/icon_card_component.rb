module Profiles
  module IconCard
    class IconCardComponent < ApplicationComponent
      def initialize(label: nil, icon:, path:)
        @icon = icon
        @label= label
        @path = path
      end

      private

      attr_reader :label, :icon, :path
    end
  end
end