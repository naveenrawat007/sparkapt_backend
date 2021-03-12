class PropertyTypeDetailSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    # data[:move_in] = object.move_in ? object.move_in.strftime("%b %dth") : ""
    # data[:move_in_date] = object.move_in ? object.move_in.strftime('%Y-%m-%d') : ''
    data[:available] = object.available ? object.available : ""
    data[:price] = object.price ? object.price : ""
    data[:notes] = object.notes ? object.notes : ""
    data[:size] = object.size ? object.size : ""
    data[:floor_plan] = object.floor_plan ? object.floor_plan : ""
    data[:property_type] = object.type ? object.try(:type)&.name : ""
    data
  end

end
