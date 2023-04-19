class Seller < ApplicationRecord
    has_and_belongs_to_many :customers
    has_many :products
    has_many :addresses, as: :addressable
end
