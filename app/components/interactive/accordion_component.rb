class Interactive::AccordionComponent < ApplicationComponent
  def initialize(items: [], html_options: {})
    @items = items
    @html_options = html_options
  end

  private

  attr_reader :items, :html_options

  def accordion_classes
    merge_classes(
      'divide-y divide-gray-200 border border-gray-200 rounded-lg',
      html_options[:class]
    )
  end

  def item_header_classes
    'w-full px-4 py-3 text-left text-sm font-medium text-gray-900 bg-gray-50 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-violet-500'
  end

  def item_content_classes
    'px-4 py-3 text-sm text-gray-700 bg-white'
  end
end
