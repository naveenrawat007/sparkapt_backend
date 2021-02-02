class ForgetPasswordWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(user_id, domain)
    user = User.find_by(id: user_id)
    if user
      if user.email.blank? == false
        UserWelcomeMailer.forget_password(user, domain).deliver
      end
    end
  end

end
