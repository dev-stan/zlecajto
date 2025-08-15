# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  private

  def css_classes(*classes)
    classes.flatten.compact.reject(&:blank?).join(' ')
  end

  def merge_classes(*classes)
    css_classes(*classes)
  end

  # Helper for consistent spacing
  def spacing_classes(size = :md)
    case size
    when :sm then 'p-2 gap-2'
    when :md then 'p-4 gap-4'
    when :lg then 'p-6 gap-6'
    else size
    end
  end

  # Helper for consistent colors
  def color_classes(variant = :primary)
    case variant
    when :primary then 'bg-violet-600 text-white hover:bg-violet-700'
    when :secondary then 'bg-gray-200 text-gray-900 hover:bg-gray-300'
    when :success then 'bg-green-600 text-white hover:bg-green-700'
    when :danger then 'bg-red-600 text-white hover:bg-red-700'
    else variant
    end
  end
end
