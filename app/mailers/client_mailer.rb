class ClientMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.client_mailer.Registration.subject
  #
  def Registration
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
