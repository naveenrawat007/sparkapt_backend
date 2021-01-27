class UserSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:token] = object.auth_token
    data[:id] = object.id
    data[:first_name] = object.first_name ? object.first_name : ""
    data[:last_name] = object.last_name ? object.last_name : ""
    data[:email] = object.email ? object.email : ""
    data[:phone_no] = object.phone_no ? object.phone_no : ""
    data[:is_admin] = object.is_admin
    data
  end

end
