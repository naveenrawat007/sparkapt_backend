class ClientSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:first_name] = object.first_name ? object.first_name : ""
    data[:last_name] = object.last_name ? object.last_name : ""
    data[:email] = object.email ? object.email : ""
    data[:phone] = object.phone ? object.phone : ""
    data[:budget] = object.budget
    data[:move_in_date] = object.move_in_date
    data[:notes] = object.notes
    data
  end

end
