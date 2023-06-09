class ClaimResolution < ApplicationRecord
  belongs_to :warranty_claim 
  has_one :invoice, through: :warranty_claim 
  validates :status, :description , presence: true
  validates :description , length: {minimum: 10, maximum: 1000}
  #where(status: ["Accepted", "In Progress"])
  scope :pending, -> { ClaimResolution.where(status:  ["Accepted","In Progress","Shipped"]) }
  scope :resolved, -> { ClaimResolution.where(status:  ["Rejected","Closed"]) }


  before_create :set_resolution_description


    
  def set_resolution_description 
      self.description = "Our Team will Validate your claim"
  end
end