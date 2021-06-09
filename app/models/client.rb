class Client < ApplicationRecord
  belongs_to :user
  belongs_to :city
  has_many :client_reports, dependent: :destroy
  has_many :reports, through: :client_reports, dependent: :destroy
end
