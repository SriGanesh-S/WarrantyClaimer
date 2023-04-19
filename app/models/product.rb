class Product < ApplicationRecord
    belongs_to :seller
    has_many :warranty_claims
    has_many :customers, through: :warranty_claims
    has_many :claim_statuses, through: :warranty_claims
end
