class UserWelcomeMailer < ApplicationMailer

  def welcome(user)
    @user = User.find(user)
    mail(to: [@user.email] ,subject: "Welcome to SparkAPT… 😊")
	end

  def forget_password(user, domain)
    @user = User.find(user)
    @domain = domain
    mail(to: [@user.email] ,subject: "Forget Password")
  end

  def contact_inquiry(id)
    @inquiry = Contactinquiry.find_by(id: id)
    mail(to: 'info@goodlifelocating.com', subject: "Inquiry")
  end

  def account_approve(user_id)
    @user = User.find(user_id)
    @admin_mail = User.find_by(is_admin: true)&.email
    mail(to: @admin_mail,subject: "New User Added: Needs Approval")
  end

  def property_report(code, email, domain, user_email)
    @domain = domain
    @code = code
    mail(to: email , reply_to: user_email, subject: "Property Report Detail")
  end

  def tour_req(params)
    @name = params[:client_name]
    @property_name = params[:name]
    @date = Date.parse(params[:startDate]).strftime("%b, %d, %Y")
    @time = params[:time]
    mail(to: params[:agentEmail], subject: "Property Tour Request")
  end

end
