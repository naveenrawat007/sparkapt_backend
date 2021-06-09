class Report < ApplicationRecord
  has_many :client_reports
  has_many :clients, through: :client_reports
end
