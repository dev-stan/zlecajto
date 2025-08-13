class BadgeComponent < ViewComponent::Base
  # Small colored label.
  # Variants: :gray, :green, :yellow, :price (green accent), :outline
  VARIANT_CLASSES = {
    gray:   "bg-gray-100 text-gray-700 ring-gray-200",
    green:  "bg-green-100 text-green-700 ring-green-200",
    yellow: "bg-yellow-100 text-yellow-800 ring-yellow-200",
    price:  "bg-emerald-600 text-white ring-emerald-500/50",
    outline: "bg-white text-emerald-700 ring-emerald-300"
  }.freeze

  def initialize(text:, variant: :gray)
    @text = text
    @variant = normalize_variant(variant)
  end

  def css_classes
    base = "inline-flex items-center justify-center h-5 px-2 rounded text-xs font-medium leading-none ring-1 ring-inset"
    color = VARIANT_CLASSES[@variant]
    "#{base} #{color}"
  end

  private

  def normalize_variant(v)
    sym = v.to_sym rescue :gray
    VARIANT_CLASSES.key?(sym) ? sym : :gray
  end
end