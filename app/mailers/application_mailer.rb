# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Zlecajto <admin@zlecajto.pl>'
  layout 'mailer'
end
