class WarrantyClaim < ApplicationRecord
  belongs_to :invoice
  has_one :claim_resolution
  validates :problem_description , presence: true


  scope :open, -> { joins(:claim_resolution).where(claim_resolutions: { status: ["Accepted", "In Progress", "Shipped"] }) }
  scope :closed, -> { joins(:claim_resolution).where(claim_resolutions: { status: ["Rejected", "Closed"] }) }
end
