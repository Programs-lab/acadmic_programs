class User < ApplicationRecord
  include PgSearch
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  pg_search_scope :search_by_personal_information, against: [:first_name, :last_name, :id_number]
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
  has_many :doctor_appointment_reports, class_name: 'AppointmentReport', foreign_key: 'doctor_id'
  has_many :patient_appointments, class_name: 'Appointment', foreign_key: 'patient_id'
  has_many :patient_medical_records, class_name: 'MedicalRecord', foreign_key: 'patient_id'
  validates_uniqueness_of :id_number
  has_one_attached :avatar



  def active_for_authentication?
    super and !self.disabled?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name_changed?
    first_name_changed? || last_name_changed?
  end

  def set_default_role
    self.role ||= :patient
  end

  def generate_password
    generated_password =  Devise.friendly_token.first(8)
    self.password = generated_password
  end

end
