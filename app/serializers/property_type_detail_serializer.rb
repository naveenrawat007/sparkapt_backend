class PropertyTypeDetailSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:move_in] = object.move_in ? object.move_in.strftime('%m/%d/%Y') : ""
    data[:price] = object.price ? object.price : ""
    data[:notes] = object.notes ? object.notes : ""
    data[:property_type] = object.type ? object.try(:type)&.name : ""
    data
  end

end
