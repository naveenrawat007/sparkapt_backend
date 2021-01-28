class UserWelcomeMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: [@user.email], subject: "Welcome to SmartApt… 😊")    
	end

end
