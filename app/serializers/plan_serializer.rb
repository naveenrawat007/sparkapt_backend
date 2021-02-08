class PlanSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:name] = object.name ? object.name : ""
    data[:amount] = object.amount ? object.amount : ""
    data[:interval] = object.interval ? object.interval : ""
    data[:stripe_plan_id] = object.stripe_plan_id ? object.stripe_plan_id : ""
    data
  end

end
