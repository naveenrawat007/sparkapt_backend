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
    data[:is_checked] = false
    data[:web_link] = (object.web_link == "none" || object.web_link == "None" || object.web_link == "NA" || object.web_link == "N/A" || object.web_link == "N/a" || object.web_link == "n/a" || object.web_link == "na") ? "" : object.web_link

    data[:photo_gallery_link] = (object.photo_gallery_link == "none" || object.photo_gallery_link == "None" || object.photo_gallery_link == "NA" || object.photo_gallery_link == "N/A" || object.photo_gallery_link == "N/a" || object.photo_gallery_link == "n/a" || object.photo_gallery_link == "na") ? "" : object.photo_gallery_link

    data[:floor_plan_link] = (object.floor_plan_link == "none" || object.floor_plan_link == "None" || object.floor_plan_link == "NA" || object.floor_plan_link == "N/A" || object.floor_plan_link == "N/a" || object.floor_plan_link == "n/a" || object.floor_plan_link == "na") ? "" : object.floor_plan_link

    data[:google_review_link] = (object.google_review_link == "none" || object.google_review_link == "None" || object.google_review_link == "NA" || object.google_review_link == "N/A" || object.google_review_link == "N/a" || object.google_review_link == "n/a" || object.google_review_link == "na") ? "" : object.google_review_link


    data[:image] = object.image.present? ? object.image.url : ""
    data[:image_file_name] = object.image_file_name ? object.image_file_name : "Select Image"
    data[:manager_name] = object.manager_name ? object.manager_name : ""
    data[:google_map] = object.google_map ? object.google_map : ""
    data[:built_year] = object.built_year ? object.built_year : ""
    data[:renovated] = object.renovated ? object.renovated : ""
    data[:escort] = object.escort ? object.escort : ""
    data[:send_escort] = object.send_escort ? object.send_escort : ""
    data[:management_company] = object.management_company ? object.management_company : ""
    data[:manager_name] = object.manager_name ? object.manager_name : ""
    data[:google_rating] = object.google_rating ? object.google_rating : ""
    data[:property_type_details] = ActiveModelSerializers::SerializableResource.new(object.type_details.order(move_in: :asc), each_serializer: PropertyTypeDetailSerializer)
    data
  end

end
