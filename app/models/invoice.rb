class Invoice < ApplicationRecord
  belongs_to :product
  belongs_to :customer
  has_one :warranty_claim
  has_one :claim_resolution, through: :warranty_claim




  scope :has_claimed, -> { joins(:warranty_claim).distinct }
  scope :not_claimed, -> { left_outer_joins(:warranty_claim).where(warranty_claim: { id: nil }) }

end
