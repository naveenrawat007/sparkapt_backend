class GuestSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:first_name] = object.first_name ? object.first_name : ""
    data[:last_name] = object.last_name ? object.last_name : ""
    data[:email] = object.email ? object.email : ""
    data[:phone] = object.phone ? object.phone : ""
    data[:move_in] = object.move_in ? object.move_in.strftime("%d %b, %Y") : ""
    data[:pet_number] = object.pet_number ? object.pet_number : ""
    data[:pet_type] = object.pet_type ? object.pet_type : ""
    data[:budget] = object.budget ? object.budget : ""
    data[:pet_name] = object.pet_name ? object.pet_name : ""
    data[:communities] = object.communities ? object.communities : ""
    data[:preferences] = object.preferences ? object.preferences : ""
    data
  end

end
