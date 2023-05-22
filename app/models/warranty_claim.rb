class WarrantyClaim < ApplicationRecord
  belongs_to :invoice 
  has_one :claim_resolution ,dependent: :destroy
  validates :problem_description , presence: true


  scope :open_claims, -> { joins(:claim_resolution).where(claim_resolutions: { status: ["Accepted", "In Progress", "Shipped"] }) }
  scope :closed_claims, -> { joins(:claim_resolution).where(claim_resolutions: { status: ["Rejected", "Closed"] }) }
end
