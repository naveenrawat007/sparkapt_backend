class UserWelcomeMailer < ApplicationMailer

  def welcome(user)
    @user = User.find(user)
    mail(to: [@user.email], from:"admin@geniusaptsearch.com" ,subject: "Welcome to SmartApt… 😊")
	end

  def forget_password(user, domain)
    @user = User.find(user)
    @domain = domain
    mail(to: [@user.email], from:"admin@geniusaptsearch.com" ,subject: "Forget Password 😊")
  end

end
