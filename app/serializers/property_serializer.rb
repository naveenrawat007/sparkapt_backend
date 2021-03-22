class PropertySerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:name] = object.name ? object.name : ""
    data[:email] = object.email ? object.email : ""
    data[:specials] = object.specials ? object.specials : ""
    data[:price] = object.price ? object.price : ""
    data[:phone] = object.phone ? object.phone : ""
    data[:submarket] = object.submarket ? object.submarket : ""
    data[:zip] = object.zip ? object.zip : ""
    data[:lat] = object.lat ? object.lat : ""
    data[:city] = object&.city ? object&.city&.name : ""
    data[:long] = object.long ? object.long : ""
    data[:address] = object.address ? object.address : ""
    data[:web_link] = object.web_link ? object.web_link : ""
    data[:photo_gallery_link] = object.photo_gallery_link ? object.photo_gallery_link : ""
    data[:image] = object.image.present? ? object.image.url : ""
    data[:image_file_name] = object.image_file_name ? object.image_file_name : "Select Image"
    data[:manager_name] = object.manager_name ? object.manager_name : ""
    data[:google_map] = object.google_map ? object.google_map : ""
    data[:built_year] = object.built_year ? object.built_year : ""
    data[:escort] = object.escort ? object.escort : ""
    data[:management_company] = object.management_company ? object.management_company : ""
    data[:manager_name] = object.manager_name ? object.manager_name : ""
    data[:google_rating] = object.google_rating ? object.google_rating : ""
    data[:property_type_details] = ActiveModelSerializers::SerializableResource.new(object.type_details.order(created_at: :asc), each_serializer: PropertyTypeDetailSerializer)
    data
  end

end
