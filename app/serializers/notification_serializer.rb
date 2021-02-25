class NotificationSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:title] = object.title ? object.title : ""
    data[:description] = object.description ? object.description : ""
    data[:datetime] = object.created_at ? object.created_at.strftime("%a, %d %b %y %I:%M %p") : ""
    data
  end

end
