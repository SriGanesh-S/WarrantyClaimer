class Invoice < ApplicationRecord
  belongs_to :product 
  belongs_to :customer
  has_one :warranty_claim , dependent: :destroy
  has_one :claim_resolution, through: :warranty_claim,dependent: :destroy
  before_validation :set_date
  validates :purchase_date , presence: true 
  validates :cust_email , presence: true , format:{with: /\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+/, message: 'please enter a valid email' }
  validate :validate_purchase_date 
  


  scope :has_claimed, -> { joins(:warranty_claim).distinct }
  scope :not_claimed, -> { left_outer_joins(:warranty_claim).where(warranty_claim: { id: nil }) }
def set_date
   if self.purchase_date == nil
    self.purchase_date=Date.current
   end

  end

  private

  def validate_purchase_date
    if purchase_date.present? && purchase_date > Date.current
      errors.add(:purchase_date, "cannot be in the future")
    end
  end

  

  

end
