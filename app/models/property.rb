class Property < ApplicationRecord
  has_many :property_types, dependent: :destroy
  has_many :type_details, dependent: :destroy
  has_many :types, through: :property_types, dependent: :destroy
  belongs_to :city

  scope :price_filter, ->(min,max) { where('price >= ? AND price <= ?', min, max) }
  scope :built_year_filter, ->(from_year,to_year) { where('built_year >= ? AND built_year <= ?', from_year, to_year) }
  scope :escort_filter, -> (escort_percent) {where("escort > ?", escort_percent)}
  scope :search_filter, -> (search_str) {where("lower(name) LIKE :search OR lower(phone) LIKE :search OR lower(email) LIKE :search OR cast(price AS TEXT) LIKE :search OR cast(built_year AS TEXT) LIKE :search OR lower(manager_name) LIKE :search OR lower(management_company) LIKE :search OR cast(escort AS TEXT) LIKE :search", search: "%#{search_str.downcase}%")} 

end
