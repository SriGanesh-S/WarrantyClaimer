class WarrantyClaim < ApplicationRecord
  belongs_to :invoice 
  has_one :claim_resolution ,dependent: :destroy
  validates :problem_description , presence: true ,length: {minimum: 10, maximum: 1000}
  validate :validate_claim_period

  scope :open_claims, -> { joins(:claim_resolution).where(claim_resolutions: { status: ["Accepted", "In Progress", "Shipped"] }) }
  scope :closed_claims, -> { joins(:claim_resolution).where(claim_resolutions: { status: ["Rejected", "Closed"] }) }


  def validate_claim_period
    invoice= Invoice.find_by(id: invoice_id)
    if invoice && invoice.purchase_date.present? && invoice.purchase_date <1.year.ago
      errors.add(:purchase_date, "Warranty period is over")
    end
  end
end
