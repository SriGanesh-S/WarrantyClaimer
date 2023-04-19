class Customer < ApplicationRecord
    has_and_belongs_to_many :sellers
    has_many :warranty_claims
    has_many :products , through: :warranty_claims
    has_many :addresses, as: :addressable
end
