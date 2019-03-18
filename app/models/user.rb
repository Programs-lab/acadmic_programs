class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_create :set_default_role
  devise :database_authenticatable,
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

end
