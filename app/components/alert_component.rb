class AlertComponent < ViewComponent::Base
  # Simple alert banner with success (green) and error (red) variants.
  # Usage: render AlertComponent.new(message: "Saved!", variant: :success)
  # Params:
  #  message: String (required)
  #  variant: Symbol/String (:success or :error) defaults to :success
  def initialize(message:, variant: :success)
    @message = message
    @variant = variant.to_sym
  end

  def variant_classes
    case @variant
    when :error, :danger
      "bg-red-50 border-red-200 text-red-800"
    else # success default
      "bg-green-50 border-green-200 text-green-800"
    end
  end
end