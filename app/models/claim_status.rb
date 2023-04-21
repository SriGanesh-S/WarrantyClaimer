class ClaimStatus < ApplicationRecord
  belongs_to :warranty_claim
  has_one :product, through: :warranty_claim 
  validates :warranty_claim_id ,uniqueness: true
end
