class LeadSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:name] = object.name ? object.name : ""
    data[:email] = object.email ? object.email : ""
    data[:phone] = object.phone ? object.phone : ""
    data[:city] = object.city ? object.city : ""
    data[:reach_out] = object.reach_out ? object.reach_out.capitalize : ""
    data[:move_in] = object.move_in ? object.move_in.strftime("%d %b, %Y") : ""
    data[:bedrooms] = object.bedrooms ? object.bedrooms : ""
    data[:bathrooms] = object.bathrooms ? object.bathrooms : ""
    data[:budget] = object.budget ? object.budget : ""
    data[:comment] = object.comment ? object.comment : ""
    data[:imp_details] = object.important_to_you ? object.important_to_you : ""
    data
  end

end
