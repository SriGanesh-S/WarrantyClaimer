class Seller < ApplicationRecord
    has_and_belongs_to_many :customers ,join_table: :customers_sellers
    has_many :products
    has_many :addresses, as: :addressable
    validates :name , :email , presence: true
    validates :email ,uniqueness: true , format:{with: /\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+/, message: 'please enter a valid email'
   }
    validates :name ,length: {minimum: 3, maximum: 25}
end
