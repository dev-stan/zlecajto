class Cards::TaskCardComponent < ApplicationComponent
  def initialize(task:, show_actions: true, html_options: {})
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
    # task.image.present? ? task.image : 'https://i.imgur.com/iyJqQH3.jpeg'
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
