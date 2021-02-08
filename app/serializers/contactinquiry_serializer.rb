class ContactinquirySerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:email] = object.email ? object.email : ""
    data[:phone] = object.phone ? object.phone : ""
    data[:inquiry_reason] = object.inquiry_reason ? object.inquiry_reason : ""
    data[:message] = object.message ? object.message : ""
    data
  end

end
