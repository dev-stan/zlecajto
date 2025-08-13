class CardComponent < ViewComponent::Base
  def initialize(title:, text: nil, body: nil, image_link: nil, image_alt: nil, price: nil, link_url: nil, link_text: nil)
    @title = title
    @text = text.presence || body.to_s
    @image_link = image_link
    @image_alt = (image_alt.presence || title) if image_link
    @price = price.presence
  end

  def show_image?
    @image_link.present?
  end

  def price?
    @price.present?
  end
end