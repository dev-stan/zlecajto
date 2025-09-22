class UserMailer < ApplicationMailer
  default from: 'no-reply@zlecajto.pl'

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to MyApp')
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
