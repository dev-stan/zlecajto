class AccordionComponent < ViewComponent::Base
  # Renders an accessible accordion.
  # Pass items: [{ title: "Question?", content: "Answer." }, ...]
  def initialize(items: [])
    @items = items
    @base_id = "accordion-#{object_id}"
  end

  def item_button_id(index)
    "#{@base_id}-btn-#{index}"
  end

  def item_panel_id(index)
    "#{@base_id}-panel-#{index}"
  end
end