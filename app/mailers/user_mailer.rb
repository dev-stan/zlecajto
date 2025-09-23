class UserMailer < ApplicationMailer
  def welcome(user_id)
    @user = User.find(user_id)

    mail(
      to: @user.email,
      subject: 'Welcome!',
      headers: {
        'X-Mailgun-Template' => 'welcome_email',
        'X-Mailgun-Variables' => { test: 'test' }.to_json
      }
    ) do |format|
      # Provide a minimal non-empty body to avoid edge cases with "empty" messages
      format.text { render plain: ' ' }
    end
  end

  def new_submission(user)
    @user = user
    mail(to: @user.email, subject: 'New Submission Received')
  end

  def task_created(user)
    @user = user
    mail(to: @user.email, subject: 'Your Task Has Been Created')
  end
end
