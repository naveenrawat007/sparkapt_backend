class PropertyType < ApplicationRecord
  belongs_to :property
  belongs_to :type
end
