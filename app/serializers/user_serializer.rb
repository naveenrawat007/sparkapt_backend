class UserSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:token] = object.auth_token
    data[:id] = object.id
    data[:name] = object.name ? object.name : ""
    data[:first_name] = object.first_name ? object.first_name : ""
    data[:last_name] = object.last_name ? object.last_name : ""
    data[:email] = object.email ? object.email : ""
    data[:license_no] = object.license_no ? object.license_no : ""
    data[:approved] = object.approved ? object.approved : ""
    data[:city] = object&.city ? object&.city&.name : ""
    data[:phone_no] = object.phone_no ? object.phone_no : ""
    data[:is_admin] = object.is_admin
    data[:is_trial] = object.is_trial
    data[:trial_start] = object.trial_start
    data[:trial_end] = object.trial_end
    data[:subscription] = object.subscriptions.last ? object.subscriptions.last : ""
    data[:plan] = object.subscriptions.last ? object.subscriptions.last.plan.name : ""
    data
  end

end
