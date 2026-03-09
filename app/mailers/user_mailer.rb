class UserMailer < ApplicationMailer
  default from: "signupnotification@z.com"

  def welcome email
    @user = params[:user]
    @url = "http://example.com/login"
    mail(to: @user.email, subject: "Welcome to Z")
  end
end
