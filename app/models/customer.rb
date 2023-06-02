class Customer < ApplicationRecord
    validates :name , :email ,:phone_no, presence: true
    validates :name ,length: {minimum: 1, maximum: 25}
    validates :name, format: { with: /\A[A-Za-z\s.\-]+\z/, message: "only allows alphabets, spaces, dots, and hyphens" }

    validates :email ,uniqueness: true , format:{ with: /\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+/, message: 'please enter a valid email' }
    validates :phone_no ,length: {is: 10},numericality: true ,presence: true,format:{ with: /[9876]{1}\d{9}/, message: 'please enter a valid phone number' }
    validates :age, presence: true, numericality: { only_integer: true , greater_than: 5,less_than: 100}
    validates :gender , presence: true ,format: { with: /\A[a-z A-Z]+\z/, message: "only allows alphabets" }

    
    has_and_belongs_to_many :sellers ,join_table: :customers_sellers
    has_many :invoices , dependent: :destroy
    has_many :addresses, as: :addressable, dependent: :destroy
    has_many :products , through: :invoices
    has_many :warranty_claims , through: :invoices
    has_many :claim_resolutions, through: :warranty_claims
    has_one :user, as: :userable, dependent: :destroy
    
    scope :has_purchased, -> { joins(:invoices).distinct }
    scope :not_purchased, -> { left_outer_joins(:invoices).where(invoices: { id: nil }) }


end
