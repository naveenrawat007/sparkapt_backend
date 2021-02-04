class UserWelcomeMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: [@user.email], subject: "Welcome to SmartApt… 😊")
	end

  def forget_password(user, domain)
    @user = user
    @domain = domain
    mail(to: [@user.email], subject: "Forget Password 😊")
  end

end
