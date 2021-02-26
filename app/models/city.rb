class City < ApplicationRecord
  has_many :clients
  has_many :properties
end
