# frozen_string_literal: true

module TasksHelper
  def formatted_due_date(task)
    I18n.with_locale(:pl) do
      wday = I18n.l(task.due_date.to_date, format: '%A')
      wday_cap = wday[0].upcase + wday[1..]
      "#{wday_cap}, #{task.due_date.strftime('%d.%m')}"
    end
  end

  def formatted_created_at(task)
    formatted_date(task.created_at)
  end

  def formatted_date(datetime)
    I18n.with_locale(:pl) { I18n.l(datetime, format: :short_day_and_date) }
  end

  def formatted_salary(task)
    "#{task.salary} ZŁ"
  end
end
