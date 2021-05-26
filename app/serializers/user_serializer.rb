class UserSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:token] = object.auth_token
    data[:id] = object.id
    data[:name] = object.name ? object.name : ""
    data[:is_trial] = object.is_trial ? object.is_trial : ""
    data[:first_name] = object.first_name ? object.first_name : ""
    data[:last_name] = object.last_name ? object.last_name : ""
    data[:email] = object.email ? object.email : ""
    data[:license_no] = object.license_no ? object.license_no : ""
    data[:approved] = object.approved ? object.approved : ""
    data[:city] = object&.city ? object&.city&.name : ""
    data[:phone_no] = object.phone_no ? object.phone_no : ""
    data[:is_admin] = object.is_admin
    data[:is_va] = object.is_va
    data[:status] = object.status
    data[:subscription] = object.subscriptions.last ? object.subscriptions.last : ""
    data[:plan] = object.subscriptions.last ? object.subscriptions.last.plan.name : ""
    data
  end

end
