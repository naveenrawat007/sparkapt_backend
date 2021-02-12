class SubscriptionSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:email] = object.user ? object.user.email : ""
    data[:plan] = object.plan ? object.plan.name : ""
    data[:amount] = object.plan ? object.plan.amount : ""
    data[:interval] = object.plan ? object.plan.interval : ""
    data[:is_active] = object.active ? object.active : ""
    data[:status] = object.status ? object.status : ""
    data[:start_date] = object.current_start_datetime ? object.current_start_datetime.strftime("%a, %d %b %Y %I:%M %p") : ""
    data[:end_date] = object.current_end_datetime ? object.current_end_datetime.strftime("%a, %d %b %Y %I:%M %p") : ""
    data
  end

end
