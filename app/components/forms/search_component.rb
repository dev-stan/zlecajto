# frozen_string_literal: true

module Forms
  class SearchComponent < ApplicationComponent
    def initialize(placeholder: 'Szukaj zadań...', action: nil, method: :get, html_options: {})
      super()
      @placeholder = placeholder
      @action = action
      @method = method
      @html_options = html_options
    end

    private

    attr_reader :placeholder, :action, :method, :html_options

    def form_classes
      merge_classes(
        'flex items-center w-full max-w-md mx-auto bg-secondary rounded-lg shadow-sm border border-gray-300 focus-within:ring-2 focus-within:ring-violet-500 focus-within:border-violet-500',
        html_options[:class]
      )
    end

    def input_classes
      'flex-1 px-4 py-2 text-base text-gray-900 bg-transparent border-none outline-none placeholder-gray-500'
    end

    def button_classes
      'px-4 py-2 text-violet-600 hover:text-violet-700 focus:outline-none'
    end
  end
end
