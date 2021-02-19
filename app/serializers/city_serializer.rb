class CitySerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:value] = object.id
    data[:label] = object.name ? object.name : ""
    data
  end

end
