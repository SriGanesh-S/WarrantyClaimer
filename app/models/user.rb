class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to   :userable ,polymorphic: true ,dependent: :destroy



  # Devise authentication 
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  def seller?
    role=="Seller"
  end
  def customer?
     role=="Customer"
  end

  scope :customer, -> { User.where("role=?","Customer"  ) }
  scope :seller , -> { User.where("role= ?","Seller") }



  
end
