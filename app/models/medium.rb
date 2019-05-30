class Medium < ApplicationRecord
  mount_uploader :file_name, MediaUploader
  belongs_to :appointment_report
end
