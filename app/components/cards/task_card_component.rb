# frozen_string_literal: true

module Cards
  class TaskCardComponent < ApplicationComponent
    def initialize(task:, show_actions: true, show_image: true, highlight: false, html_options: {})
      super()
      @task = task
      @show_actions = show_actions
      @show_image = show_image
      @highlight = highlight
      @html_options = html_options
    end

    private

    attr_reader :task, :show_actions, :show_image, :highlight, :html_options

    def container_classes
      base = 'rounded-2xl overflow-hidden flex flex-col h-full focus:outline-none focus:ring-2 focus:ring-blue-500 transition-shadow hover:shadow-md'
      bg = highlight ? 'bg-red-100 border border-red-200' : 'bg-secondary'
      merge_classes(bg, base)
    end

    def card_classes
      merge_classes(
        'group bg-gray-200 rounded-2xl border border-gray-100 overflow-hidden hover:shadow-md transition-shadow duration-200',
        html_options[:class]
      )
    end

    def title
      task.title
    end

    def price
      return unless task.salary.present?

      # Display without emoji, green color handled in template. Avoid Kernel#format name clash.
      value = task.salary.to_f
      "#{value.round}PLN"
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
      list = []
      list << payment_method_badge if payment_method_badge
      list << category_badge if category_badge
      list
    end

    def show_actions?
      show_actions
    end

    def show_image?
      !!show_image
    end

    # --- New UI helpers ---

    def payment_method_badge
      return unless task.payment_method.present?

      variant = case task.payment_method.downcase
                when 'blik' then :blue
                when 'gotówka', 'gotowka' then :yellow
                else :green
                end
      { text: task.payment_method, variant: variant }
    end

    def category_badge
      return unless task.category.present?

      { text: task.category, variant: :red }
    end

    def location
      task.location.presence
    end

    def formatted_due_date
      return unless task.due_date.present?

      I18n.with_locale(:pl) do
        # Abbrev weekday with capital first letter + date
        wday = I18n.l(task.due_date.to_date, format: '%a')
        wday_cap = wday[0].upcase + wday[1..]
        "#{wday_cap}, #{task.due_date.strftime('%d.%m')}"
      end
    rescue StandardError
      task.due_date.strftime('%d.%m')
    end

    TIMESLOT_RANGES = {
      'rano' => '8:00 - 12:00',
      'popoludnie' => '12:00 - 16:00',
      'wieczor' => '16:00 - 20:00'
    }.freeze

    def timeslot_range
      return unless task.timeslot.present?

      TIMESLOT_RANGES[task.timeslot] || task.timeslot
    end

    def offers_count_text
      count = task.submissions.size
      "#{count} ofert"
    end

    def user_display_name
      return 'Anonim' unless task.user

      fn = task.user.first_name.to_s.strip
      ln = task.user.last_name.to_s.strip
      if fn.present? && ln.present?
        "#{fn} #{ln.first}."
      elsif fn.present?
        fn
      elsif ln.present?
        ln
      else
        task.user.email.split('@').first
      end
    end

    def user_initials
      return '?' unless task.user

      initials = [task.user.first_name, task.user.last_name].compact.map { |n| n[0] }.join
      initials.presence || 'U'
    end

    def reviews_count
      task.reviews.size
    end
  end
end
