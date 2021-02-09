class UserWelcomeMailer < ApplicationMailer

  def welcome(user)
    @user = User.find(user)
    mail(to: [@user.email], from:"info@goodlifelocating.com" ,subject: "Welcome to SmartApt… 😊")
	end

  def forget_password(user, domain)
    @user = User.find(user)
    @domain = domain
    mail(to: [@user.email], from:"info@goodlifelocating.com" ,subject: "Forget Password")
  end

  def contact_inquiry(id)
    @inquiry = Contactinquiry.find_by(id: id)
    mail(to: 'info@goodlifelocating.com', subject: "Inquiry")
  end

end
