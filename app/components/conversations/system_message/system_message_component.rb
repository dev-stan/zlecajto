# frozen_string_literal: true

module Conversations
  module SystemMessage
    class SystemMessageComponent < ViewComponent::Base
      COLORS = {
        red: 'red-500',
        blue: 'blue-500'
      }.freeze

      def initialize(title:, subtitle:, color: :red)
        super()
        @title = title
        @subtitle = subtitle
        @color = COLORS[color] || COLORS[:red]
      end

      private

      attr_reader :title, :subtitle, :color
    end
  end
end
