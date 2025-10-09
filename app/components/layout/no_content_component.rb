# frozen_string_literal: true

module Layout
  class NoContentComponent < ViewComponent::Base
    def initialize(message: nil)
      super()
      @message = message || 'Cicho wszędzie, głucho wszędzie, co to będzie, co to będzie...'
    end
  end
end
