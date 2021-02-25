class Property < ApplicationRecord
  has_many :property_types
  has_many :type_details
  has_many :types, through: :property_types
end
