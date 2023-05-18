class Product < ApplicationRecord
    belongs_to :seller
    has_many :invoices
   

  
    scope :sold, -> { joins(:invoices).distinct }
    scope :not_sold, -> { left_outer_joins(:invoices).where(invoices: { id: nil }) }
end
