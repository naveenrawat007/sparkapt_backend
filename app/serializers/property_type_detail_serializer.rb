class PropertyTypeDetailSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:available] = object.move_in ? object.move_in.strftime("%b %d") : ""
    data[:move_in] = object.move_in ? object.move_in.strftime('%Y-%m-%d') : ''
    data[:price] = object.price ? object.price : ""
    data[:notes] = object.notes ? object.notes : ""
    data[:size] = object.size ? object.size : ""
    data[:floor_plan] = object.floor_plan ? object.floor_plan : ""
    data[:property_type] = object.property_type_name ? object.property_type_name : ""
    data[:den] = object.den ? object.den : ""
    data[:bath] = object.bath ? object.bath : ""
    data
  end

end
