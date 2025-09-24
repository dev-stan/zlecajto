# frozen_string_literal: true

module Ui
  class FormModalComponent < ApplicationComponent
    def initialize(title:, size: :md, html_options: {})
      super()
      @title = title
      @size = (size&.to_sym || :md)
      @html_options = html_options
    end

    attr_reader :title, :size, :html_options
  end
end
