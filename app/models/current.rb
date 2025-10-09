# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :user

  def signed_in?
    user.present?
  end
end
