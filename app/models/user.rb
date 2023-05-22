class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to   :userable ,polymorphic: true ,dependent: :destroy

  def seller?
    role=="Seller"
  end
  def customer?
     role=="Customer"
  end

  scope :customer, -> { User.where("role=?","Customer"  ) }
  scope :seller , -> { User.where("role= ?","Seller") }



  
end
