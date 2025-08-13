class AlertComponent < ViewComponent::Base
  def initialize(message:, variant: :success, auto_dismiss: true)
    @message = message
    @variant = variant.to_sym
    @auto_dismiss = auto_dismiss
  end

  def variant_classes
    case @variant
    when :error, :danger
      "bg-red-50 border-red-200 text-red-800"
    else # success default
      "bg-green-50 border-green-200 text-green-800"
    end
  end

  def auto_dismiss?
    @auto_dismiss
  end
end