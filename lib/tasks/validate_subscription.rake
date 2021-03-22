namespace :validate_subscription do
  desc "check all the subscriptions of user"
  task check_subscription_status: :environment do
    users = User.where(is_admin: false, is_trial: true)
    # users.each do |user|
    #   if DateTime.now.utc > user.trial_end
    #     user.update_column('is_trial', false)
    #   end
    # end
  end

end
