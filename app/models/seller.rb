class Seller < ApplicationRecord
    has_and_belongs_to_many :customers
    has_many :products
    has_many :addresses, as: :addressable
    validates :email ,uniqueness: true , format{
        with: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/, message: 'please enter a valid email'
    }
end
