class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_create :set_default_role
  before_validation :generate_password, on: :admin
  devise :invitable,
         :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :timeoutable, reconfirmable: true
  enum role: [:patient, :doctor, :admin]         
  has_one_attached :avatar


 def set_default_role
   self.role ||= :patient                            
 end

 def generate_password
  generated_password =  Devise.friendly_token.first(8)
  self.password = generated_password
 end

end
