# frozen_string_literal: true

module Ui
  class DividerWithLabelComponent < ApplicationComponent
    def initialize(label:)
      @label = label
    end
  end
end
