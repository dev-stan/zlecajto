# frozen_string_literal: true

module Ui
  class RadioButtonComponent < ApplicationComponent
    def initialize(name:, value:, checked: false, id: nil, label: nil, style: :default,
                   html_options: {})
      super()
      @name = name
      @value = value
      @checked = checked
      @id = id || generate_id
      @label = label
      @style = style.to_sym
      @options = html_options
    end

    private

    attr_reader :name, :value, :checked, :id, :label, :style, :options

    def generate_id
      "#{name.to_s.parameterize}_#{value.to_s.parameterize}"
    end
  end
end
