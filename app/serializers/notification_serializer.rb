class NotificationSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:title] = object.title ? object.title : ""
    data[:description] = object.description ? object.description : ""
    data
  end

end
