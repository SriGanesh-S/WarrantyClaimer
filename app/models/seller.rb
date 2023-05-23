class Seller < ApplicationRecord
    has_and_belongs_to_many :customers ,join_table: :customers_sellers
    has_many :products , dependent: :destroy
    has_many :addresses, as: :addressable, dependent: :destroy
    has_many :invoices, through: :products
    has_many :warranty_claims, through: :invoices
    has_many :claim_resolutions, through: :warranty_claims
    validates :name , :email,:phone_no , presence: true
    validates :phone_no ,length: {is: 10},numericality: true ,presence: true,format:{ with: /[9876]{1}\d{9}/, message: 'please enter a valid phone number' }
    validates :email ,uniqueness: true , format:{with: /\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+/, message: 'please enter a valid email'
   }
    validates :name ,length: {minimum: 3, maximum: 25}




    scope :has_sold, -> { joins(:invoices).distinct }
    scope :not_sold, -> { left_outer_joins(:invoices).where(invoices: { id: nil }) }
end
