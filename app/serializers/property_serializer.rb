class PropertySerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:name] = object.name ? object.name : ""
    data[:email] = object.email ? object.email : ""
    data[:specials] = object.specials ? object.specials : ""
    data[:price] = object.price ? object.price : ""
    data[:submarket] = object.submarket ? object.submarket : ""
    data[:zip] = object.zip ? object.zip : ""
    data[:built_year] = object.built_year ? object.built_year : ""
    data[:escort] = object.escort ? object.escort : ""
    data[:management_company] = object.management_company ? object.management_company : ""
    data[:manager_name] = object.manager_name ? object.manager_name : ""
    data[:google_rating] = object.google_rating ? object.google_rating : ""
    data[:property_type_details] = ActiveModelSerializers::SerializableResource.new(object.type_details, each_serializer: PropertyTypeDetailSerializer)
    data
  end

end
