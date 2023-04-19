class ClaimStatus < ApplicationRecord
  belongs_to :warranty_claim
  has_one :product, through: :warranty_claim 
end
