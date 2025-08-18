# frozen_string_literal: true

module Interactive
  class AccordionComponent < ApplicationComponent
    def initialize(items: [], html_options: {})
      super()
      @items = items
      @html_options = html_options
    end

    private

    attr_reader :items, :html_options

    def accordion_classes
      merge_classes(
        'space-y-4',
        html_options[:class]
      )
    end

    def item_header_classes
      'w-full flex items-center justify-between text-left text-sm font-medium text-gray-800 rounded-xl bg-green-50/70 hover:bg-green-50 border border-green-400/70 px-6 py-4 focus:outline-none focus-visible:ring-2 focus-visible:ring-green-500 transition-colors'
    end

    def item_content_classes
      'px-6 pt-2 pb-6 text-sm text-gray-700'
    end
  end
end
