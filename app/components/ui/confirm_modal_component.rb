# frozen_string_literal: true

module Ui
  # A reusable confirmation modal.
  #
  # Usage pattern (recommended):
  #
  #   .wrapper{ data: { controller: 'confirm-modal' } }
  #     = render(Ui::ButtonComponent.new(text: 'Do it', button: true, html_options: { data: { action: 'click->confirm-modal#open' } }))
  #     = render(Ui::ConfirmModalComponent.new(
  #           title: 'Are you sure?',
  #           body: 'This action cannot be undone.',
  #           confirm_text: 'Confirm',
  #           cancel_text: 'Cancel',
  #           confirm_path: some_path,
  #           confirm_method: :patch
  #         ))
  #
  # Multiple instances can live on the same page. Each wrapper needs its own
  # data-controller scope so the trigger button opens only its sibling modal.
  class ConfirmModalComponent < ApplicationComponent
    def initialize(
      title:,
      body: nil,
      confirm_text: 'Confirm',
      cancel_text: 'Cancel',
      confirm_path: nil,
      confirm_method: :post,
      cancel_path: nil,
      cancel_method: :get,
      confirm_turbo_frame: '_top',
      confirm_variant: :danger,
      cancel_variant: :secondary,
      size: :md,
      html_options: {}
    )
      super()
      @title = title
      @body = body
      @confirm_text = confirm_text
      @cancel_text = cancel_text
      @confirm_path = confirm_path
      @confirm_method = (confirm_method&.to_sym || :post)
      @cancel_path = cancel_path
      @cancel_method = (cancel_method&.to_sym || :get)
      @confirm_turbo_frame = confirm_turbo_frame
      @confirm_variant = (confirm_variant&.to_sym || :danger)
      @cancel_variant = (cancel_variant&.to_sym || :secondary)
      @size = (size&.to_sym || :md)
      @html_options = html_options
    end

    attr_reader :title, :body, :confirm_text, :cancel_text,
        :confirm_path, :confirm_method, :cancel_path,
        :cancel_method, :confirm_turbo_frame, :confirm_variant,
        :cancel_variant, :size, :html_options
  end
end
