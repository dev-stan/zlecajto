module ApplicationHelper
  # Polish pluralization helper
  def pluralize_polish(count, singular, few, many)
    case count
    when 1
      singular
    when 2..4
      few
    else
      many
    end
  end
end
