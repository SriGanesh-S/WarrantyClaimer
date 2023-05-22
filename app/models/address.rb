class Address < ApplicationRecord
    belongs_to :addressable, polymorphic: true 
    validates :door_no , :street , :district ,:state,presence: true
    validates :phone ,length: {is: 10},numericality: true ,presence: true,format:{ with: /[9876]{1}\d{9}/, message: 'please enter a valid phone number' }
    validates :pin_code ,length: {is: 6},numericality: true ,presence: true

end
