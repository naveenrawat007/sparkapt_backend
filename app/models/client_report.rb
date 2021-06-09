class ClientReport < ApplicationRecord
  belongs_to :report
  belongs_to :client
end
