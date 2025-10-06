class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :submission
  after_create :send_new_answer_email
  validates :message, presence: true, length: { maximum: 1000 }

  private

  def send_new_answer_email
    recipient_user = user == submission.user ? submission.task.user : submission.user

    MailgunTemplateJob.perform_later(to: recipient_user.email, template: 'prod_new_answer', subject: 'Nowa odpowiedź! ',
                                     variables: { first_name: recipient_user.first_name, answer_message: message })
  end
end
