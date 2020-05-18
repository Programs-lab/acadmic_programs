class User < ApplicationRecord
  include PgSearch
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  pg_search_scope :search_by_personal_information, against: [:first_name, :last_name, :id_number]
  before_create :set_default_role
  before_validation :generate_password, on: :admin
  belongs_to :academic_program, optional: true
  belongs_to :academic_department, optional: true
  has_many :notifications
  devise :invitable,
         :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :timeoutable, reconfirmable: true
  enum role: [:director, :admin, :functionary]
  validates_uniqueness_of :id_number
  mount_uploader :avatar, ImageUploader
  mount_uploader :signature, SignatureUploader
  validates :id_number, presence: true


  def active_for_authentication?
    super and !self.disabled?
  end


  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name_changed?
    first_name_changed? || last_name_changed?
  end

  def set_default_role
    self.role ||= :director
  end

  def generate_password
    generated_password =  Devise.friendly_token.first(8)
    self.password = generated_password
  end

end
