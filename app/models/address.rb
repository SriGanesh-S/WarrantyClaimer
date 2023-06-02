class Address < ApplicationRecord
    belongs_to :addressable, polymorphic: true 
    validates :door_no , :street , :district ,:state,presence: true
    validates :phone ,length: {is: 10},numericality: true ,presence: true,format:{ with: /[9876]{1}\d{9}/, message: 'please enter a valid phone number' }
    validates :pin_code ,length: {is: 6},numericality: true ,presence: true
    validates :district, :state ,  format: { with: /\A[A-Za-z\s\-]+\z/, message: "only allows alphabets, spaces and hyphens" }
    




    scope :sellers, -> { Address.where("addressable_type=?",'Seller')}
    scope :customers, -> { Address.where("addressable_type=?","Customer"  )}
  

    

end
