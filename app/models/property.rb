class Property < ApplicationRecord
  has_many :property_types, dependent: :destroy
  has_many :type_details, dependent: :destroy
  has_many :types, through: :property_types, dependent: :destroy
  belongs_to :city

  has_attached_file :image
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  scope :min_price_filter, ->(min) { joins(:type_details).where('type_details.price >= ?', min) }
  scope :max_price_filter, ->(max) { joins(:type_details).where('type_details.price <= ?', max) }

  scope :year_from_filter, ->(from_year) { where('built_year >= ?', from_year) }
  scope :year_to_filter, ->(to_year) { where('built_year <= ?', to_year) }

  scope :market_filter, -> (submarket) {where(submarket: submarket)}
  scope :escort_filter, -> (escort_percent) {where("escort >= ?", escort_percent)}
  scope :send_escort_filter, -> (send_escort_percent) {where("send_escort >= ?", send_escort_percent)}
  scope :zip_filter, -> (zip) {where(zip: zip)}
  scope :sq_feet_filter, -> (sq_feet) {joins(:type_details).where("size >= ?", sq_feet)}

  scope :bedroom_filter, -> (property_type) {joins(:type_details).where("type_details.property_type_name = ?", property_type)}

  scope :search_filter, -> (search_str) {joins(:type_details).where("lower(name) LIKE :search OR lower(phone) LIKE :search OR lower(email) LIKE :search OR cast(type_details.price AS TEXT) LIKE :search OR cast(built_year AS TEXT) LIKE :search OR lower(manager_name) LIKE :search OR lower(management_company) LIKE :search OR cast(escort AS TEXT) LIKE :search", search: "%#{search_str.downcase}%")}

end
