# frozen_string_literal: true

module Conversations
  module SystemMessage
    class SystemMessageComponent < ViewComponent::Base
      COLORS = {
        red: 'red-500',
        blue: 'blue-500'
      }.freeze

      def initialize(title:, subtitle:, color: :red, image_path: nil, html_options: {})
        super()
        @title = title
        @subtitle = subtitle
        @color = COLORS[color] || COLORS[:red]
        @image_path = image_path
        @html_options = html_options
      end

      private

      attr_reader :title, :subtitle, :color, :image_path, :html_options
    end
  end
end
