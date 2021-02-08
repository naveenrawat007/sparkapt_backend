class SubscriptionSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:email] = object.user ? object.user.email : ""
    data[:plan] = object.plan ? object.plan.name : ""
    data[:amount] = object.plan ? object.plan.amount : ""
    data[:interval] = object.plan ? object.plan.interval : ""
    data[:is_active] = object.active ? object.active : ""
    data[:current_start_datetime] = object.current_start_datetime ? object.current_start_datetime : ""
    data[:current_end_datetime] = object.current_end_datetime ? object.current_end_datetime : ""
    data
  end

end
