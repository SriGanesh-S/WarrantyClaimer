class Customer < ApplicationRecord
    validates :name , :email , presence: true
    validates :name ,length: {minimum: 3, maximum: 25}
    validates :email ,uniqueness: true , format:{ with: /\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+/, message: 'please enter a valid email' }
    has_and_belongs_to_many :sellers ,join_table: :customers_sellers
    has_many :warranty_claims
    has_many :products , through: :warranty_claims
    has_many :addresses, as: :addressable
end
