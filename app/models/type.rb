class Type < ApplicationRecord
  has_many :type_details
  has_many :property_types
  has_many :properties, through: :property_types
end
