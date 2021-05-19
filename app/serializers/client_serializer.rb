class ClientSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:first_name] = object.first_name ? object.first_name : ""
    data[:last_name] = object.last_name ? object.last_name : ""
    data[:name] = object.name ? object.name : ""
    data[:email] = object.email ? object.email : ""
    data[:phone] = object.phone ? object.phone : ""
    data[:status] = object.status ? object.status : ""
    data[:budget] = object.budget
    data[:mve_in_date] = object.move_in_date ? object.move_in_date.strftime('%b %d, %Y') : ''
    data[:move_in_date] = object.move_in_date ? object.move_in_date.strftime('%Y-%m-%d') : ''
    data[:lease_end_date] = object.lease_end_date ? object.lease_end_date.strftime('%Y-%m-%d') : ''
    data[:next_follow_up] = object.next_follow_up ? object.next_follow_up.strftime('%Y-%m-%d') : ''
    data[:notes] = object.notes
    data
  end

end
