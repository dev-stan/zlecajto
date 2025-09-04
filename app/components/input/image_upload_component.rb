# frozen_string_literal: true

class Input::ImageUploadComponent < ApplicationComponent
  # Accepts:
  # - form: form builder (optional, for form_with or form_for)
  # - name: input name (string, required)
  # - label: label text (string, required)
  # - multiple: boolean (default: false)
  # - direct_upload: boolean (default: true)
  # - value: prefilled value (optional, for edit forms)
  # - input_id: string (optional, for label association)
  # - required: boolean (default: false)
  # - hint: string (optional)
  # - html_options: hash (optional, for extra input options)
  def initialize(name:, label: nil, form: nil, multiple: false, direct_upload: true, value: nil, input_id: nil,
                 required: false, hint: nil, html_options: {}, limit: nil)
    super()
    @form = form
    @name = name
    @label = label
    @multiple = multiple
    @direct_upload = direct_upload
    @value = value
    @input_id = input_id || "#{name.to_s.parameterize}-input"
    @required = required
    @hint = hint
    @html_options = html_options
    @limit = limit
  end

  private

  attr_reader :form, :name, :label, :multiple, :direct_upload, :value, :input_id, :required, :hint, :html_options,
              :limit
end
