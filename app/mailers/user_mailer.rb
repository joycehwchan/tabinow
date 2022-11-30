class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user

    mail(to: @user.email, subject: "Welcome to TabiNow")
  end

  def itinerary(user, itinerary)
    @user = user
    @itinerary = itinerary
    mail(to: @user.email, subject: "Here is your itinerary")
  end
end
