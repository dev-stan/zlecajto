class Layout::NoContentComponent < ViewComponent::Base
  def initialize(message: nil)
    super()
    @message = message || 'Cicho wszędzie, głucho wszędzie, co to będzie, co to będzie...'
  end
end
