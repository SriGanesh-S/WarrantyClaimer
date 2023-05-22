class ClaimResolution < ApplicationRecord
  belongs_to :warranty_claim 
  has_one :invoice, through: :warranty_claim 
  validates :status, :description , presence: true
  #where(status: ["Accepted", "In Progress"])
  scope :resolved , -> { ClaimResolution.where(status:  ["Accepted","In Progress","Shipped"]) }
  scope :pending , -> { ClaimResolution.where(status:  ["Rejected","Closed"]) }

end