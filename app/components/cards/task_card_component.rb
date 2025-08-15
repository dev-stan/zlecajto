# frozen_string_literal: true

module Cards
  class TaskCardComponent < ApplicationComponent
    def initialize(task:, show_actions: true, html_options: {})
      super()
      @task = task
      @show_actions = show_actions
      @html_options = html_options
    end

    private

    attr_reader :task, :show_actions, :html_options

    def card_classes
      merge_classes(
        'bg-white rounded-lg shadow-md border border-gray-200 overflow-hidden hover:shadow-lg transition-shadow duration-200',
        html_options[:class]
      )
    end

    def title
      task.title
    end

    def description
      task.description
    end

    def price
      "💵 #{task.salary}PLN" if task.salary.present?
    end

    def image_url
      return placeholder_image unless task.photos.attached?

      first = task.photos.first
      if first.nil?
        placeholder_image
      else
        begin
          if image_blob?(first)
            variant = first.variant(resize_to_fill: [640, 360])
            helpers.url_for(variant)
          else
            Rails.application.routes.url_helpers.rails_blob_url(first, only_path: true)
          end
        rescue StandardError => e
          Rails.logger.warn("Image variant generation failed: #{e.class}: #{e.message}")
          placeholder_image
        end
      end
    end

    def image_blob?(blob)
      blob.content_type&.start_with?('image/') && blob.variable?
    end

    def placeholder_image
      'https://i.imgur.com/iyJqQH3.jpeg'
    end

    def badges
      badges = []
      badges << { text: 'Zweryfikowany użytkownik', variant: :green } if task.user&.verified?
      badges << { text: task.category, variant: :violet } if task.category.present?
      badges
    end

    def show_actions?
      show_actions
    end
  end
end
