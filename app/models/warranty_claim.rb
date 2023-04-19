class WarrantyClaim < ApplicationRecord
  belongs_to :customer
  belongs_to :product
  has_one :claim_status
end
