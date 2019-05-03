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
  belongs_to :company, optional: true
  has_many :doctor_appointments, class_name: 'Appointment', foreign_key: 'doctor_id'
  has_many :doctor_working_weeks, class_name: 'WorkingWeek', foreign_key: 'doctor_id'
  has_many :patient_appointments, class_name: 'Appointment', foreign_key: 'patient_id'
  has_many :patient_medical_records, class_name: 'MedicalRecord', foreign_key: 'patient_id'
  has_one_attached :avatar


  def active_for_authentication?
    super and !self.disabled?
  end

  def set_default_role
    self.role ||= :patient
  end

  def generate_password
    generated_password =  Devise.friendly_token.first(8)
    self.password = generated_password
  end

end
