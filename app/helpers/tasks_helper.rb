# frozen_string_literal: true

module TasksHelper
  def formatted_due_date(task)
    I18n.with_locale(:pl) do
      wday = I18n.l(task.due_date.to_date, format: '%A')
      wday_cap = wday[0].upcase + wday[1..]
      "#{wday_cap}, #{task.due_date.strftime('%d.%m')}"
    end
  end

  def formatted_salary(task)
    "#{task.salary} PLN"
  end
end
