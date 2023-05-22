class Customer < ApplicationRecord
    validates :name , :email ,:phone_no, presence: true
    validates :name ,length: {minimum: 3, maximum: 25}
    validates :email ,uniqueness: true , format:{ with: /\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+/, message: 'please enter a valid email' }
    validates :phone_no ,length: {is: 10},numericality: true ,presence: true,format:{ with: /[9876]{1}\d{9}/, message: 'please enter a valid phone number' }

    
    has_and_belongs_to_many :sellers ,join_table: :customers_sellers
    has_many :invoices 
    has_many :products , through: :invoices
    has_many :addresses, as: :addressable
end
